/**
 * @license
 * Copyright 2026 Google LLC
 * SPDX-License-Identifier: Apache-2.0
 */

const CONSTANT_VALUES = {
  GLOBALS: {
    LABELS: {
      BUG: 'bug',
      COMP_AGENT_CAPABILITIES: 'comp:agent capabilities',
      COMP_ARTIFACTS: 'comp:artifacts',
      COMP_AUTH: 'comp:auth',
      COMP_BILLING_QUOTA: 'comp:billing/quota',
      COMP_CONVERSATIONS: 'comp:conversations',
      COMP_CUSTOMIZATIONS: 'comp:customizations',
      DOCUMENTATION: 'documentation',
      ENHANCEMENT: 'enhancement',
      FEATURE_REQUEST: 'feature request',
      FEEDBACK: 'feedback',
      GOOD_FIRST_ISSUE: 'good first issue',
      INSTALL: 'install',
      PERFORMANCE: 'performance',
      QUESTION: 'question',
      REGRESSION_ISSUE: 'regression issue',
      SECURITY: 'security',
      STAT_COMMUNITY_SUPPORT: 'stat:community support',
      SUPPORT: 'support',
    },
    STATE: { CLOSED: 'closed' },
  },
  MODULE: {
    CSAT: {
      YES: 'Yes',
      NO: 'No',
      BASE_URL: 'https://docs.google.com/forms/d/e/1FAIpQLSdxycEiO21kzWaArk3OvtDkTh05i3nbgFlj-OckUyqIp0B-iw/viewform?',
      SATISFACTION_PARAM: 'entry.2005374974=',
      ISSUEID_PARAM: '&entry.695090381=',
      MSG: 'Are you satisfied with the resolution of your issue?',
    }
  }
};

/**
 * Invoked from csat workflow file to post survey link
 * in closed issue.
 * @param {!Object.<string,!Object>} github contains pre defined functions.
 *  context Information about the workflow run.
 * @return {null}
 */
module.exports = async ({ github, context }) => {
    const issue = context.payload.issue.html_url;
    
    // Check if any label matches (case-insensitive) the supported CSAT labels.
    const supportedLabels = Object.values(CONSTANT_VALUES.GLOBALS.LABELS);
    const hasMatchingLabel = context.payload.issue.labels.some(label => {
        const name = label.name.toLowerCase();
        return supportedLabels.some(supportedLabel => name.includes(supportedLabel));
    });

    if (hasMatchingLabel) {
        console.log(`Posting CSAT survey for issue =${issue}`);
        const baseUrl = CONSTANT_VALUES.MODULE.CSAT.BASE_URL;

        const yesCsat = `<a href="${baseUrl + CONSTANT_VALUES.MODULE.CSAT.SATISFACTION_PARAM +
            CONSTANT_VALUES.MODULE.CSAT.YES +
            CONSTANT_VALUES.MODULE.CSAT.ISSUEID_PARAM + encodeURIComponent(issue)}"> ${CONSTANT_VALUES.MODULE.CSAT.YES}</a>`;

        const noCsat = `<a href="${baseUrl + CONSTANT_VALUES.MODULE.CSAT.SATISFACTION_PARAM +
            CONSTANT_VALUES.MODULE.CSAT.NO +
            CONSTANT_VALUES.MODULE.CSAT.ISSUEID_PARAM + encodeURIComponent(issue)}"> ${CONSTANT_VALUES.MODULE.CSAT.NO}</a>`;

        const comment = CONSTANT_VALUES.MODULE.CSAT.MSG + '\n' + yesCsat + '\n' +
            noCsat + '\n';
        const issueNumber = context.issue.number ?? context.payload.issue.number;

        await github.rest.issues.createComment({
            issue_number: issueNumber,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: comment
        });
    }
};
