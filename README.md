# DevOps Internship - Task 3: Infrastructure as Code (IaC) with Terraform

## 📌 Objective
Provision a local Docker container using Terraform, verify the running container, inspect the Terraform state, and cleanly destroy the infrastructure using Infrastructure as Code best practices.

---

## 🛠️ Tools Used
- **Terraform** (v1.0+)
- **Docker Desktop**
- **Docker Provider** (`kreuzwerker/docker` ~> 3.0.2)
- **NGINX Image** (`nginx:latest`)

---

## 📁 Repository Structure
```text
Task 3/
├── main.tf              # Terraform configuration (Provider, Image, Container, Outputs)
├── execution_logs.txt    # Real terminal logs recorded during execution
├── README.md             # Project documentation and interview questions
├── .gitignore           # Ignores Terraform state and cache files
└── screenshots/         # Visual proof of plan, apply, browser test, and destroy
```

---

## ⚙️ Configuration Details (`main.tf`)
The Terraform configuration provisions:
- **Provider:** `kreuzwerker/docker` (version `~> 3.0.2`)
- **Resource 1:** `docker_image.nginx_image` pulling `nginx:latest`
- **Resource 2:** `docker_container.nginx_server` named `task3-nginx-webserver`
  - Internal Port: `80`
  - External Port: `8081` (accessible at `http://localhost:8081`)
- **Outputs:**
  - `container_id`: ID of the running container
  - `application_url`: `http://localhost:8081`

---

## 🚀 Step-by-Step Instructions

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   *Downloads the required `kreuzwerker/docker` provider plugin.*

2. **Generate and Preview Execution Plan:**
   ```bash
   terraform plan
   ```
   *Shows the resources Terraform will create without making actual changes.*

3. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```
   *Pulls the NGINX image and launches the container.*

4. **Verify Container via Docker CLI:**
   ```bash
   docker ps
   ```
   *Confirms `task3-nginx-webserver` is running with port 8081->80 mapped.*

5. **Verify Web Server in Browser:**
   - Open http://localhost:8081 to view the "Welcome to nginx!" page.

6. **Inspect Terraform State:**
   ```bash
   terraform state list
   terraform state show docker_container.nginx_server
   ```

7. **Clean Up / Destroy Infrastructure:**
   ```bash
   terraform destroy -auto-approve
   ```

8. **Confirm Removal:**
   ```bash
   docker ps -a
   ```

---

## 💡 Interview Questions & Answers

### 1. What is IaC?
> Infrastructure as Code (IaC) is the practice of managing and provisioning IT infrastructure (networks, virtual machines, containers, load balancers, etc.) using machine-readable definition files rather than manual hardware configuration or interactive configuration tools.

### 2. How does Terraform work?
> Terraform operates on a declarative model. You define the desired end state in configuration files (`.tf`). Terraform reads your configuration, inspects the current state of resources via provider plugins, calculates the difference (delta) through `terraform plan`, and makes the necessary API calls to reach the target state via `terraform apply`.

### 3. What is the Terraform state file?
> The state file (`terraform.tfstate`) is a JSON file that records the mapping between resources declared in your configuration and the real-world resources created in the target environment. It tracks metadata, manages resource dependencies, and serves as the single source of truth for drift detection.

### 4. What is the difference between `apply` and `plan`?
> - **`terraform plan`:** A dry-run preview command that checks configuration against current state and displays the planned additions, changes, or deletions without modifying real infrastructure.
> - **`terraform apply`:** Executes the actions proposed in the plan by interacting with provider APIs and updates the state file.

### 5. What are Terraform providers?
> Providers are plugins that Terraform uses to interact with cloud providers, SaaS platforms, and APIs (such as Docker, AWS, Azure, GCP, GitHub, Kubernetes). They expose resources and data sources for Terraform to manage.

### 6. What is resource dependency?
> Resource dependency dictates the order in which Terraform provisions or tears down resources.
> - **Implicit Dependency:** Formed automatically when a resource references an attribute of another resource (e.g., `image = docker_image.nginx_image.image_id`).
> - **Explicit Dependency:** Declared manually using the `depends_on = [ ... ]` meta-argument when Terraform cannot automatically detect the dependency.

### 7. How do you handle secret variables in Terraform?
> - Mark sensitive variables with `sensitive = true` to prevent them from showing in logs and CLI output.
> - Pass values via environment variables (`TF_VAR_<var_name>`) or `.tfvars` files that are added to `.gitignore`.
> - Retrieve secrets at runtime from dedicated secret management tools (e.g., HashiCorp Vault, AWS Secrets Manager).
> - Store state in a secure, encrypted remote backend with access controls.

### 8. Explain the benefits of Terraform.
> - **Platform Agnostic:** Manage multi-cloud and on-premises infrastructure using a consistent language and workflow.
> - **Declarative:** You define the desired end state, and Terraform handles the mechanics.
> - **State Management & Idempotency:** Safely re-run configurations without creating duplicate resources.
> - **Execution Plan & Safety:** Preview exactly what will happen before applying changes to prevent accidental destruction.
> - **Modularity & Collaboration:** Reusable modules enable standardized, shareable infrastructure templates across teams.
