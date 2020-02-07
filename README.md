## Terraform task
___
Group  | Name
------------- | -------------
kh032  | Serhii Chernukha

### Task:
Task:
Deploy VPC and **3** subnets:
-	Services_subnet
-	Backend_subnet
-	Frontend_subnet

**Services_subnet** will be accessible only from **Backend_subnet** and might be without opportunity accessing internet. **Backend_subnet** will have the separate configuration but with ability to work with internet in one way (NAT model). **Frontend subnet** instance might be accessible from external hosts with 443 port. (22, 80, 3389 – restricted).
Deploy  3 ( > if possible )  AWS instances [Linux] in different subnets. Install apache on Frontend_subnet based one using “user data”.

*NOTES:*
1)	Use loops (for/foreach preferable)  for resources creation ;
2)	Split resources creation into 2 modules: networking and instances ;
3)	Avoid any hardcode in non-variables files ;  

**Acceptance criteria:**
Terraform code pushed in your github/gitlab repo(add me to your repository members list w/ following email), tested in different scenario and passed verification. Testing scenario completed (manually login on each instance and check possibility to access one by one, frontend instance accessible from outside. Services_subnet based host have to be reachable only from Backend_subnet based instance.

___

## Terraform project

We use AWS as a provider in our task. Start working with Terraform via command *terraform init* in our project directory for terraform initialization. Create main.tf and variables.tf files in root directory. Also create terraform.tfvars secure file with access credentials (don't forget to add this file in .gitignore). In our case **main.tf** consist of *provider* block, 2 *modules* (see README in modules directory) and look like this way:
![](https://i.screenshot.net/m6dl7f6)

And **variables.tf** file which is using for the  defining variables values:
![](https://i.screenshot.net/wzk95fp)
___

Start project with *terraform init* for already created modules and continue with *terraform apply*

![](https://i.screenshot.net/wymxna8)

Press "yes" and go to AWS website for checking functionality.

Check that VPC, route tables and 3 subnets has been created

![](https://i.screenshot.net/wpo0zsy)
![](https://i.screenshot.net/wogpzs6)
![](https://i.screenshot.net/wxe34se)

Also check created instances in EC2. You should have **5** instances ( 1 frontend instance, 1 backend instance, 3 service instances). There are 3 service instances in *service subnet* cause **count loop** was used for creating instance multiple times (by "inst_array" variable):

```
resource "aws_instance" "se_inst" {
count = length(var.inst_array)
ami = var.ami
vpc_security_group_ids = [aws_security_group.services_secgr.id]
subnet_id = var.subnet_id_se
instance_type = var.t2shape
tags = {
 Name = var.inst_array[count.index]
 }
 key_name = aws_key_pair.mykey.key_name
}
```

![](https://i.screenshot.net/w4jpjsj)

After that connect to **frontend instance** via SSH using IPv4 Public IP and RSA key:

![](https://i.screenshot.net/wqnopce)

This "frontend instance"
included in "frontend subnet" and *frontend security group*. NAT Server, Apache and connection to Internet are included in this instance.

Standard Apache and SSH listening ports was changed to **443** and **1992** respectively by using the  following commands in *user data.sh:*
```
#!/bin/bash
echo -e "\nPort 1992" >> /etc/ssh/sshd_config
sudo service sshd restart
sudo yum -y update
sudo yum -y install httpd
sudo echo -e "\nListen 443" >>/etc/httpd/config/httpd.conf
sudo service httpd start
```
Lets check Apache in web using frontend instance IPv4 Public IP and 443 port:

![](https://i.screenshot.net/w39v9ud)

Now go to **.ssh** directory and create **id_rsa** file with private key from "mykey" key pair. This key must not be publicly viewable for SSH to work. Use this command if needed: ```chmod 400 mykey.pem```

Check connection to **backend instance** from frontend instance using SSH command and Private IP:

![](https://i.screenshot.net/w0md8t0)

This instance is included in *backend subnet* and *backend security group* and use frontend instance for connecting to Internet:

![](https://i.screenshot.net/wxrd8sm)

Now go to **.ssh** directory and create **id_rsa** file with private key like in the previous case and check connection to **services instance** from frontend instance using SSH command and Private IP:

![](https://i.screenshot.net/wlo1vtw)

*Service instance* have only ingress access rule for 22 TCP port so any egress connections will be refused:

![](https://i.screenshot.net/w9yw5sw)

Every service instance in this subnet have same configuration

## Thats all, folks!
