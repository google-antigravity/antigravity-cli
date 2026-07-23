/** Automatically assign issues to users in the `assigneesList` 
 *  on a rotating basis.

  @param {!object}
    GitHub objects can call GitHub APIs using their built-in library functions.
    The context object contains issue details.
*/

module.exports = async ({ github, context }) => {
  if (!context.payload.issue) {
    console.log("Not an issue event, skipping.");
    return;
  }

  const assigneesList = ["rshashank17"];
  const issueNumber = context.payload.issue.number;

  console.log("assignee list", assigneesList);
  console.log("entered auto assignment for issue: ", issueNumber);
  if (!assigneesList.length) {
    console.log("No assignees found for this repo.");
    return;
  }
  let noOfAssignees = assigneesList.length;
  let selection = issueNumber % noOfAssignees;
  let assigneeForIssue = assigneesList[selection];

  console.log(
    "issue Number = ",
    issueNumber + " , assigning to: ",
    assigneeForIssue
  );
  return github.rest.issues.addAssignees({
    issue_number: context.issue.number,
    owner: context.repo.owner,
    repo: context.repo.repo,
    assignees: [assigneeForIssue],
  });
};
