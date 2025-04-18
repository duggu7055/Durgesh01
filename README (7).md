
# Workflow of ansible playbooks’s CI.



This document provides a detailed overview of the CI workflow for Ansible playbooks, explaining each step from committing changes to receiving feedback.

---
## Author information
| **Created**       | **Version** | **Last Modified** | **Author**        | **Level**            | **Reviewer**  |
|--------------------|-------------|-------------------|-------------------|------------------------|---------------|
| 17-04-2025         |           |        | Durgesh Sharma    | Internal review        | Pritam        |
|  17-04-2025          |          |         | Durgesh Sharma      | L0 Review | Shreya Jaiswal        |

---
## **Workflow**


![Workflow Diagram](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj3GDc-9T6KOrR08eP8-bra_dA3SFT9_OGWxc2HY1Bt5QGTcX-HwRr_WF4kKpOVdoV_jo1YbgFeqkZ4i2wHeTGRjhvY5E1DxB4Gz_cdlaD8Y7jKU-lMX-oWnrmIJlPgIqejle7KIbyZmiP1jdsHsYTMW9ptWQaV0drS_zYUdUyL5-DIYE9HSdWzApTF5-o/s16000/workflow1.jpg)







## STEP 1. Commit Playbooks (Developer's Machine → VCS)


**What happens?**  
- Developers create or modify Ansible playbooks locally.
- They push the changes to a version control repository.
- This action triggers the CI process.

## STEP 2. Run CI Pipeline (CI Server)


**What happens?**  
- The CI server detects changes in the repository (via webhooks or polling).
- It starts the pipeline defined in a configuration file (e.g., `.gitlab-ci.yml` or `.github/workflows`).

## STEP 3. Automated Testing (Test Environment)


**What happens?**  
- Linting and syntax checks (e.g., `ansible-lint`) run on the CI server.
- Test playbooks in isolated environments to ensure correctness and idempotency.

## STEP 4. Feedback Generation (CI Server)


**What happens?**  
- The CI pipeline aggregates the test results, logs, and potential errors or warnings.
- It formats them into reports.

## STEP 5. Feedback Delivery (CI Server → Developer's Machine)


- **Pull Request Comments:** Comments added to the merge request or pull request.
- **Email Notifications:** Alerts about the pipeline status.
- **CI Dashboard:** A user interface to view logs and test results.

---

This setup ensures a clear path from developer changes to automated testing and feedback, making it easy to pinpoint where each action occurs.


