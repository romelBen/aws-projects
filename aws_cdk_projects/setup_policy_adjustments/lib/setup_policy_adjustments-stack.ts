import * as cdk from '@aws-cdk/core';
import * as iam from '@aws-cdk/aws-iam';
import { userInfo } from 'os';
import { Resolver } from 'dns';

export class SetupPolicyAdjustmentsStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Must import the username into aws cdk
    const userBob = iam.User.fromUserName(this, 'userName', 'bob');

    // Here lies the userBoundary Role with three policies.
    const userBoundaryPolicy = new iam.ManagedPolicy(this, "a4luserboundary", {
      managedPolicyName: "a4luserboundary",
      statements: [
        new iam.PolicyStatement({
          effect: iam.Effect.ALLOW,
          actions: [
            "s3:*",
            "cloudwatch:*",
            "ec2:*"
          ],
          resources: ["*"]
        }),
        new iam.PolicyStatement({
          effect: iam.Effect.ALLOW,
          actions: [
            "iam:ListUsers",
            "iam:GetAccountPasswordPolicy"
          ],
          resources: ["*"]
        }),
        new iam.PolicyStatement({
          effect: iam.Effect.ALLOW,
          actions: [
            "iam:*AccessKey*",
            "iam:ChangePassword",
            "iam:GetUser",
            "iam:*ServiceSpecificCredential*",
            "iam:*SigningCertificate*"
          ],
          resources: ["arn:aws:iam::*:user/${aws:username}"]
        }),
      ],
    });

    // Here lies the adminBoundary Role with four policies.
    const adminBoundaryPolicy = new iam.ManagedPolicy(this, "a4ladminboundary", {
      managedPolicyName: "a4ladminboundary",
      statements: [
        new iam.PolicyStatement({
          effect: iam.Effect.ALLOW,
          actions: [
            "iam:CreateUser",
            "iam:DeleteUserPolicy",
            "iam:AttachUserPolicy",
            "iam:DetachUserPolicy",
            "iam:PutUserPermissionsBoundary",
            "iam:PutUserPolicy"
          ],
          resources: ["*"],
          conditions: {StringEquals: {
            "iam:PermissionsBoundary": "arn:aws:iam::<EnterMasterAccountHere>:policy/a4luserboundary" // Master Account number
          }}
        }),
        new iam.PolicyStatement({
          effect: iam.Effect.ALLOW,
          actions: [
            "cloudwatch:*",
            "iam:GetUser",
            "iam:ListUsers",
            "iam:DeleteUser",
            "iam:UpdateUser",
            "iam:CreateAccessKey",
            "iam:CreateLoginProfile",
            "iam:GetAccountPasswordPolicy",
            "iam:GetLoginProfile",
            "iam:ListGroups",
            "iam:ListGroupsForUser",
            "iam:CreateGroup",
            "iam:GetGroup",
            "iam:DeleteGroup",
            "iam:UpdateGroup",
            "iam:CreatePolicy",
            "iam:DeletePolicy",
            "iam:DeletePolicyVersion",
            "iam:GetPolicy",
            "iam:GetPolicyVersion",
            "iam:GetUserPolicy",
            "iam:GetRolePolicy",
            "iam:ListPolicies",
            "iam:ListPolicyVersions",
            "iam:ListEntitiesForPolicy",
            "iam:ListUserPolicies",
            "iam:ListAttachedUserPolicies",
            "iam:ListRolePolicies",
            "iam:ListAttachedRolePolicies",
            "iam:SetDefaultPolicyVersion",
            "iam:SimulatePrincipalPolicy",
            "iam:SimulateCustomPolicy"
          ],
          notResources: ["arn:aws:iam::<EnterMasterAccountHere>:user/bob"] // Master Account and user name
        }),
        new iam.PolicyStatement({
          effect: iam.Effect.DENY,
          actions: [
            "iam:CreatePolicyVersion",
            "iam:DeletePolicy",
            "iam:DeletePolicyVersion",
            "iam:SetDefaultPolicyVersion"
          ],
          resources: [
            "arn:aws:iam::<EnterMasterAccountHere>:policy/a4luserboundary", // Master Account number
            "arn:aws:iam::<EnterMasterAccountHere>:policy/a4ladminboundary" // Master Account number
          ],
        }),
        new iam.PolicyStatement({
          effect: iam.Effect.DENY,
          actions: ["iam:DeleteUserPermissionsBoundary"],
          resources: ["*"]
        }),
      ],
    });

    // Here are the adminPermissionsPolicy with two policies.
    const adminPermissionsPolicy = new iam.ManagedPolicy(this, "a4ladminpermissionspolicy", {
    managedPolicyName: "a4ladminpermissionspolicy",
      statements: [
        new iam.PolicyStatement({
          effect: iam.Effect.ALLOW,
          actions: ["iam:*"],
          resources: ["*"]
        }),
        new iam.PolicyStatement({
          effect: iam.Effect.ALLOW,
          actions: [
            "cloudwatch:GetDashboard",
            "cloudwatch:GetMetricData",
            "cloudwatch:ListDashboards",
            "cloudwatch:GetMetricStatistics",
            "cloudwatch:ListMetrics"
          ],
          resources: ["*"]
        }),
      ],
    });

    // Attach a4ladminboundary to user bob
    iam.PermissionsBoundary.of(userBob).apply(adminBoundaryPolicy);

    // Attach a4ladminpermissionspolicy to user bob
    adminPermissionsPolicy.attachToUser(userBob);

  }
}