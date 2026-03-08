# Step 2 bis: Elasticsearch Dynamic Secrets

In this step, we demonstrate how to use Vault's Database secrets engine with Elasticsearch.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
    - [Spring Boot 3.x vs 2.x Setups](#example-using-spring-boot-3x-spring-cloud-2023x)
    - [Main differences between Spring B. 2 and Spring B. 3](#main-differences-between-spring-boot-2-and-3-for-vault)
    - [Spring Boot vs Spring Cloud Starters](#spring-boot-starter-vault-config-vs-spring-cloud-starter-vault-config)
- [Implementation in Spring Boot Application](#implementation-in-spring-boot-application)
- [Infrastructure as Code (IaC) with Terraform](#infrastructure-as-code-iac-with-terraform)
- [Running the Demo](#run-it)
- [Verification and Checks](#check-it)
- [Access ElasticSearch](#access-elasticsearch-)
- [Cleanup](#cleanup)
- [References](#references)
- [Next Step](#next-step)

## Overview

The process is similar to Step 2, but adapted for a NoSQL database:

1.  Enable the **Database Secrets Engine**.
2.  Configure the connection to **Elasticsearch**.
3.  Create a **Vault Role** with specific Elasticsearch roles (e.g., `superuser`).
4.  Refactor the Spring Boot application to use `spring-cloud-vault-config-databases` with Elasticsearch properties.

The application will receive dynamic credentials for Elasticsearch at runtime, with automatic lease renewal.


## Installation 

The dependencies for **Spring Cloud Vault** depend on the version of **Spring Boot** you are using, because each Spring Boot generation is compatible with a specific **Spring Cloud** release.

Below are the correct setups for **Spring Boot 3.x** and **Spring Boot 2.x**.

### Example using **Spring Boot 3.x (Spring Cloud 2023.x)**: 

Spring Boot 3.x uses Spring Cloud 2023.x.

```xml
  <!--  Properties -->
  <properties>
     <spring-cloud.version>2023.0.2</spring-cloud.version>
  </properties>

  <!--  Dependencies -->
	<dependencies>
    <!-- Spring Cloud Vault Dependencies -->
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-vault-config</artifactId>
		</dependency>
    <!-- Addition for Dynamic Secrets (Databases) -->
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-vault-config-databases</artifactId>
		</dependency>
	</dependencies>

  <!-- Dependency Management to import the Spring Cloud dependencies -->
  <dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-dependencies</artifactId>
				<version>${spring-cloud.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>
```

### Example using **Spring Boot 2.x (Spring Cloud 2021.x)**: 

Spring Boot 2.x uses Spring Cloud 2021.x.

```xml
  <!--  Properties -->
  <properties>
     <spring-cloud.version>2021.0.8</spring-cloud.version>
  </properties>

  <!--  Dependencies -->
	<dependencies>
    <!-- Spring Cloud Vault Dependencies -->
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-vault-config</artifactId>
		</dependency>
    <!-- Addition for Dynamic Secrets (Databases) -->
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-vault-config-databases</artifactId>
		</dependency>
	</dependencies>

  <!-- Dependency Management to import the Spring Cloud dependencies -->
  <dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-dependencies</artifactId>
				<version>${spring-cloud.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>
```

### Main differences between Spring Boot 2 and 3 for Vault

| Feature                   | Spring Boot 2   | Spring Boot 3          |
| ------------------------- | --------------- | ---------------------- |
| Config loading            | `bootstrap.yml` | `spring.config.import` |
| Spring Cloud version      | 2021.x          | 2023.x                 |
| Java version              | Java 8–11       | Java 17+               |
| Recommended secret engine | KV v2 / Dynamic | KV v2 / Dynamic        |

#### NOTE : 

With **Spring Boot 3.x**, the `bootstrap.yml` file is **no longer loaded automatically** as it was in **Spring Boot 2.x**. However, you can still use it by adding the **Spring Cloud Bootstrap starter**. This is often needed for tools like **Spring Cloud Vault** or **Spring Cloud Config**.

```xml 
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bootstrap</artifactId>
</dependency>
```

#### **spring-boot-starter-vault-config** vs **spring-cloud-starter-vault-config**

The difference between **spring-boot-starter-vault-config** and **spring-cloud-starter-vault-config** mainly comes from which ecosystem manages the integration with **HashiCorp Vault** and how configuration is loaded in **Spring Boot** applications.

| Feature | **spring-boot-starter-vault-config** | **spring-cloud-starter-vault-config** |
| --- | --- | --- |
| **Ecosystem** | Spring Boot Native | Spring Cloud |
| **Configuration Loading** | `spring.config.import` in `application.yml` | `bootstrap.yml` (with `spring-cloud-starter-bootstrap`) |
| **Dependencies** | `spring-boot-starter-vault-config` | `spring-cloud-starter-vault-config` |
| **Usage** | Standalone Spring Boot applications | Spring Cloud applications (with Spring Cloud Config, etc.) |

## Implementation in Spring Boot Application



## Infrastructure as Code (IaC) with Terraform

We use **Terraform** to apply this configuration automatically. Terraform spins up as a Docker container, talks to Vault, applies the `.tf` files, and then exits.

Terraform will output the role_id and secret_id that we need to use in our application. We will use these values in the next step.

We will use the following commands to apply the configuration and extract the role_id and secret_id if you need to do it manually:

```bash
# Terraform extract role_id and secret_id from terraform output
terraform output -raw role_id
terraform output -raw secret_id
```

For more information, see the [IaC Terraform Vault](./terraform/README.md).

## Run it

Run the following command to start everything:

```bash
# Run application & tests
./run.sh 
# Or run only the application
docker-compose -f ./docker-compose.yml up -d
```

If you need to rebuild the Spring app (e.g., after a code change), use:

```bash
docker-compose up -d --build --force-recreate
```

## Check it

You can verify that the containers are running:

```bash
docker ps
```

You should see `spring-app`, `elasticsearch`, and `vault` containers up and running.

After running, you can test the application using this command 

```bash
# Run only the application test
./test.sh
```

## Access ElasticSearch : 

You can access Elasticsearch directly via curl or through a tool like Kibana or ElasticVue:

- **URL**: [http://localhost:9200](http://localhost:9200)

To verify the connection and see the dynamic user created by Vault:
```bash
curl -u "dynamic-user:password" http://localhost:9200
```

## Cleanup

Do the following commands:

```bash
$ docker-compose down
$ rm terraform/terraform.tfstate
```

## References:


## Next Step

Done with Elasticsearch dynamic secrets? Let's verify that we have the credentials. Go to [Step 3](../step3/README.md).
