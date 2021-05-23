import { expect as expectCDK, matchTemplate, MatchStyle } from '@aws-cdk/assert';
import * as cdk from '@aws-cdk/core';
import * as SetupPolicyAdjustments from '../lib/setup_policy_adjustments-stack';

test('Empty Stack', () => {
    const app = new cdk.App();
    // WHEN
    const stack = new SetupPolicyAdjustments.SetupPolicyAdjustmentsStack(app, 'MyTestStack');
    // THEN
    expectCDK(stack).to(matchTemplate({
      "Resources": {}
    }, MatchStyle.EXACT))
});
