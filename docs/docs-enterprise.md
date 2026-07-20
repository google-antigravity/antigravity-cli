[Google Antigravity](https://antigravity.google/)

Products keyboard\_arrow\_down

Use Cases keyboard\_arrow\_down

Pricing

Blog

Resources keyboard\_arrow\_down

Download download

menu

Products keyboard\_arrow\_down

Explore our next generation products

[See overview](https://antigravity.google/product)

Products

[antigravity Antigravity 2.0](https://antigravity.google/product/antigravity-2) [terminal Antigravity CLI](https://antigravity.google/product/antigravity-cli) [code Antigravity IDE](https://antigravity.google/product/antigravity-ide) [sdk Antigravity SDK](https://antigravity.google/product/antigravity-sdk)

Use Cases keyboard\_arrow\_down

Built for developers in the agent-first era

[See overview](https://antigravity.google/use-cases)

[Enterprise](https://antigravity.google/use-cases/enterprise) [Frontend](https://antigravity.google/use-cases/frontend) [Fullstack](https://antigravity.google/use-cases/fullstack) [Science](https://antigravity.google/use-cases/science) [Marketer](https://antigravity.google/use-cases/marketer)

Pricing  Blog  Resources keyboard\_arrow\_down

Everything you need to stay up-to-date and get help

[Documentation keyboard\_arrow\_right](https://antigravity.google/docs) [Changelog](https://antigravity.google/changelog) [Support](https://antigravity.google/support) [Press](https://antigravity.google/press) [Releases](https://antigravity.google/releases)

[Home](https://antigravity.google/docs/home)

Antigravity 2.0 chevron\_right

Antigravity CLI chevron\_right

Antigravity SDK chevron\_right

Antigravity IDE chevron\_right

Migration chevron\_right

[Enterprise](https://antigravity.google/docs/enterprise)

[Plans](https://antigravity.google/docs/plans)

[FAQ](https://antigravity.google/docs/faq)

- side\_navigation
- Enterprise

# Getting Started with Antigravity and Gemini Enterprise Agent Platform [link](https://antigravity.google/\#getting-started-with-antigravity-and-gemini-enterprise-agent-platform)

Supported products: Antigravity 2.0Antigravity CLI

This guide is for administrators setting up the Google Cloud environment to enable Antigravity integration with Gemini Enterprise Agent Platform. This integration allows enterprise developers to use Antigravity with models hosted in your own Google Cloud project, under Google Cloud Terms of Service, satisfying private networking and data residency requirements, and utilizing consumption-based billing.

info

**Note**: Integration is only supported for Antigravity 2.0 and Antigravity CLI. Antigravity IDE is not supported for enterprise customers.

[Supported Models](https://antigravity.google/docs/models)

## Basic Setup [link](https://antigravity.google/\#basic-setup)

### Prerequisites [link](https://antigravity.google/\#prerequisites)

Before you begin, ensure you have:

- A Google Cloud account.
- Access to the Google Cloud console.

### Step 1: Select or Create a Google Cloud Project [link](https://antigravity.google/\#step-1-select-or-create-a-google-cloud-project)

In the Google Cloud console, on the project selector page, select or create a Google Cloud project.

### Roles Required to Select or Create a Project [link](https://antigravity.google/\#roles-required-to-select-or-create-a-project)

- **Select a project**: Selecting a project doesn't require a specific IAM role—you can select any project that you've been granted a role on.

info

**Note**: To switch to a different Google Cloud project or location, you must first log out of the Antigravity CLI or Hub, then log back in and select your new project/location. Directly changing the project or location while logged in is currently not supported.

- **Create a project**: To create a project, you need the **Project Creator** role (`roles/resourcemanager.projectCreator`), which contains the `resourcemanager.projects.create` permission. [Learn how to grant roles](https://cloud.google.com/iam/docs/granting-changing-revoking-access).

info

**Note**: If you don't plan to keep the resources that you create in this procedure, create a new project instead of selecting an existing project. After you finish these steps, you can delete the project to remove all associated resources.

[Go to project selector](https://console.cloud.google.com/projectselector2)

### Step 2: Verify Billing [link](https://antigravity.google/\#step-2-verify-billing)

Verify that billing is enabled for your Google Cloud project. You can check the billing status in the [Google Cloud Billing Console](https://console.cloud.google.com/billing). For detailed instructions, see [Verify the billing status of your projects](https://cloud.google.com/billing/docs/how-to/verify-billing-enabled).

### Step 3: Enable the Agent Platform API [link](https://antigravity.google/\#step-3-enable-the-agent-platform-api)

To use Antigravity with Gemini Enterprise Agent Platform, you must enable the Agent Platform API (`aiplatform.googleapis.com`).

### Roles Required to Enable APIs [link](https://antigravity.google/\#roles-required-to-enable-apis)

To enable APIs, you need the **Service Usage Admin** IAM role (`roles/serviceusage.serviceUsageAdmin`), which contains the `serviceusage.services.enable` permission. [Learn how to grant roles](https://cloud.google.com/iam/docs/granting-changing-revoking-access).

### Enable the API [link](https://antigravity.google/\#enable-the-api)

[Enable the Agent Platform API in the API Library](https://console.cloud.google.com/apis/library/aiplatform.googleapis.com)

### User Permissions [link](https://antigravity.google/\#user-permissions)

To get the permissions that you need to use Gemini Enterprise Agent Platform, ask your administrator to grant you the **Agent Platform User** (`roles/aiplatform.user`) IAM role on your project. For more information about granting roles, see [Manage access to projects, folders, and organizations](https://cloud.google.com/iam/docs/granting-changing-revoking-access).

You might also be able to get the required permissions through [custom roles](https://cloud.google.com/iam/docs/creating-custom-roles) or other [predefined roles](https://cloud.google.com/iam/docs/roles-overview#predefined).

## Advanced Configuration [link](https://antigravity.google/\#advanced-configuration)

### Request and Response Logging [link](https://antigravity.google/\#request-and-response-logging)

For detailed instructions on how to enable and configure request and response logging for the Gemini Enterprise Agent Platform, please refer to the official documentation:

[Request and Response Logging Documentation](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/capabilities/request-response-logging)

### VPC Service Controls (VPC-SC) [link](https://antigravity.google/\#vpc-service-controls-vpc-sc)

If your organization has a service perimeter, then you must add the following resources to your perimeter:

- Agent Platform API

For detailed instructions on how to configure VPC Service Controls, please refer to the official documentation:

[VPC Service Controls Documentation](https://docs.cloud.google.com/gemini-enterprise-agent-platform/machine-learning/general/vpc-service-controls)

## Complementary Resources [link](https://antigravity.google/\#complementary-resources)

### Consumption Options [link](https://antigravity.google/\#consumption-options)

Gemini Enterprise Agent Platform offers different consumption options to suit your needs.

For detailed information on consumption options, please refer to the official documentation:

[Consumption Options Documentation](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/deploy/consumption-options)

### Deployments and Endpoints Locations [link](https://antigravity.google/\#deployments-and-endpoints-locations)

For now, Antigravity CLI and 2.0 offer 3 endpoints: global, multi-region eu, and multi-region us.

info

**Note**: Image generation is currently not available in `eu` and `us` locations.

For a full list of available locations and deployment endpoints, please refer to the official documentation:

[Deployment Endpoints Documentation](https://docs.cloud.google.com/gemini-enterprise-agent-platform/resources/locations#global)

[Firebase Studio Migration](https://antigravity.google/docs/firebase-studio-migration)

[Plans](https://antigravity.google/docs/plans)

On this Page

- Getting Started with Antigravity and Gemini Enterprise Agent Platform

- Basic Setup

- Advanced Configuration

- Complementary Resources