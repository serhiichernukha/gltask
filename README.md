## GL test task
___
Deadline  | Candidate
------------- | -------------
7/2/2020  | Serhii Chernukha

### Task:

Create Cloud infrastructure via **Terraform** wich consist of:
-	Application Load Balancer
-	EC2(Windows)
-	S3 Bucket

Connect **EC2** to the **ALB**; Create **IAM Role** for EC2 to get read permission from **S3 Bucket**; Create PowerShell script for static website deploying (content like "index.html" must be downloaded from S3during script execution).

![](https://i.paste.pics/91ba0e9e037c8ea132684547bb1c76ad.png?trs=f620bab9b8a145e7bbc0774c996ef0a07efbf147278d50b61c445cb7977ca6bd)


___

## Terraform project

We use AWS as a provider in our task. Start working with Terraform via command *terraform init* in our project directory for terraform initialization. Create main.tf and variables.tf files in root directory. Also create terraform.tfvars secure file with access credentials (advice: don't forget to add this file in .gitignore). In our case **main.tf** consist of *provider* block, 2 *resources* for VMs and 1 for Security group. And **variables.tf** file which is using for the  defining variables values.

Also create alb.tf, bucket.tf, iam.tf, network.tf, "provisioning" folder and "content" folder in root of project.
___

Start project with *terraform init* for already created resources and continue with *terraform apply*

![](https://i.paste.pics/8fd1563d0316d051932cf0f3fc8b99cd.png?trs=f620bab9b8a145e7bbc0774c996ef0a07efbf147278d50b61c445cb7977ca6bd)

Press "yes" and go to AWS website for checking functionality.

### AWS

Check that VPC, security group and 2 subnets has been created

![](https://i.paste.pics/5f511834c5daf973d24548e88a7a7282.png?trs=f620bab9b8a145e7bbc0774c996ef0a07efbf147278d50b61c445cb7977ca6bd)
![](https://i.paste.pics/cc38b6869405a3fffec1e4245690a78a.png?trs=f620bab9b8a145e7bbc0774c996ef0a07efbf147278d50b61c445cb7977ca6bd)
![](https://i.paste.pics/6ee003d00e436441d7807e42e1539b92.png?trs=f620bab9b8a145e7bbc0774c996ef0a07efbf147278d50b61c445cb7977ca6bd)

Also check created instances in EC2. It should be **2** instances ( winser1, winserv2). Each instance is being include to own **Subnet** and **Availability Zone**.

Due to requirements create **iam role**, **instance profile** and **policy**
to get permissions for EC2 to read from S3 Bucked. Content file "index.html" copying to S3 via Terraform.

![](https://i.paste.pics/d70d325ecfb60b264ea322a1e16bf394.png?trs=f620bab9b8a145e7bbc0774c996ef0a07efbf147278d50b61c445cb7977ca6bd)

Instance creating block for example.

```
resource "aws_instance" "win_web1" {
ami = var.ami
iam_instance_profile = "${aws_iam_instance_profile.my_profile.name}"
vpc_security_group_ids = ["${aws_security_group.allow.id}"]
subnet_id = tolist(data.aws_subnet_ids.all.ids)[0]
instance_type = var.t2shape
tags = {
 Name = var.servername1
 }
key_name = "terraform-key"
user_data = file("./provisioning/userdata1.ps1")
}
```


After that go to the **Load Balancer** and configure it by steps:

  - Create target groups and include instances into respectively.

  ![](https://i.paste.pics/cd8540c007728ecb2c100418910725eb.png?trs=f620bab9b8a145e7bbc0774c996ef0a07efbf147278d50b61c445cb7977ca6bd)

  - Add listner to ALB with target group (*Forward Action*) using previosly created self-signed certificate.

  ![](https://i.paste.pics/c4f979bf3e2fb4c453d25b4d11a4743d.png?trs=f620bab9b8a145e7bbc0774c996ef0a07efbf147278d50b61c445cb7977ca6bd)
