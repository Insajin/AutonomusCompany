# GitHub Projects Setup Guide

This guide explains how to set up and configure GitHub Projects for automatic issue tracking.

## Overview

GitHub Projects provides a Kanban-style board for tracking issues and pull requests. This template includes automation to move issues through the board automatically.

## Built-in Automation

GitHub Projects (beta) includes built-in automation rules:

### Default Rules

1. **Issue opened** → Automatically added to "Todo" column
2. **PR merged** → Automatically moved to "Done" column
3. **Issue closed** → Automatically moved to "Done" column

## Setup Instructions

### Step 1: Create Project Board

1. Go to your repository's **Projects** tab
2. Click **"New project"**
3. Choose **"Board"** template
4. Name it (e.g., "Development Board")

### Step 2: Configure Columns

Create these columns:

- **Todo**: New issues and tasks
- **In Progress**: Work currently being done
- **Done**: Completed items

### Step 3: Enable Automation

1. Go to Project **Settings**
2. Navigate to **Workflows**
3. Enable these automations:
   - ✅ "When items are added to the project, set status to Todo"
   - ✅ "When pull requests are merged, set status to Done"
   - ✅ "When issues are closed, set status to Done"

### Step 4: Get Project ID (Optional)

For custom automation workflows:

```bash
gh project list
```

Copy the project ID and add it to repository secrets as `GITHUB_PROJECT_ID`.

## Custom Automation (Optional)

The template includes `.github/workflows/project-board-automation.yml` for advanced automation:

- Move issue to "In Progress" when PR is opened
- Add labels based on column
- Auto-assign issues

To enable custom automation:

1. Uncomment the workflow file
2. Configure project ID in secrets
3. Customize rules as needed

## Usage

### Adding Issues to Board

Issues are automatically added when created. No manual action needed.

### Moving Items

#### Manual Movement
Drag and drop items between columns in the project board.

#### Automatic Movement
- Create PR referencing issue → Moves to "In Progress" (if custom automation enabled)
- Merge PR → Moves to "Done" (built-in)
- Close issue → Moves to "Done" (built-in)

### Linking PRs to Issues

Reference issues in PR description:

```markdown
Closes #123
Fixes #456
Resolves #789
```

## Best Practices

1. **One issue per task**: Keep issues focused and specific
2. **Update status regularly**: If not automatic, manually update
3. **Use labels**: Categorize issues with labels
4. **Archive completed items**: Periodically archive old items
5. **Review board weekly**: Keep the board up to date

## Troubleshooting

### Issues not appearing on board

- Check project automation settings
- Verify issue is open (closed issues don't auto-add)
- Manually add if automation failed

### Items not moving automatically

- Verify automation rules are enabled
- Check workflow permissions
- Review workflow run logs for errors

## Advanced Configuration

### Custom Fields

Add custom fields to track:
- Priority (High, Medium, Low)
- Effort (Story points)
- Sprint
- Assignee

### Filters and Views

Create filtered views:
- By assignee
- By label
- By milestone
- By sprint

## Integration with Workflows

The template workflows integrate with GitHub Projects:

1. **PR Review** → Creates issue comments
2. **AI Fixes** → Updates PR status
3. **CI Results** → Posts status to issues

All activity is tracked on the project board automatically.

## Resources

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Project Automation](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project)
- [GitHub CLI Projects](https://cli.github.com/manual/gh_project)
