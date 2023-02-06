---
title: "Using AWS Codepipeline AWS Codecommit and Aws Codebuild to Always Keep Your Golden AMIs Up to Date"
date: 2023-02-05T07:51:11Z
tags: [aws]
draft: false
---

# Introduction
Adoption of DevOps principles is fundamental for any company that wants to deliver solutions at great speed and agility. These principles allow you to deploy solutions in an auditable, consistent and repeatable manner.

At a minimum, you should have two environments – non production and production. Your non production environment will be used to innovate and to fix bugs. After the artifacts have been properly tested in non production, they can be promoted to the production environment, where it can be deployed using an appropriate change management process. This ensures that your production environment always runs a stable version of the artifacts and is guarded from any issues and outages.

To ensure all deployments are consistent, repeatable and are auditable, deployment pipelines must be used to deploy and update environments.

The pipelines can be configured to provision Amazon EC2 instances using the AWS supplied Amazon Machine Images (AMIs) and as part of the provisioning process, you would install additional packages and customise it to suit the use case. This is a good solution, however you will lose significant time during your deployment process since each server will have to spend additional time during this customisation process (depending on the number of additional packages and customisations, it can take anywhere from a few minutes to a couple of hours). The other problem with this approach is that since each of the servers are being customised individually, they might end up running different versions of the packages (you could version pin the packages to get around this).

A better option is to use a golden AMI for your Amazon EC2 instance deployments. A golden AMI is created using a pipeline that is different from your deployment pipeline, by installing all the additional packages and customisations on the AWS supplied AMI. Your deployment pipeline will then use the golden AMI instead of the AWS supplied AMI. This will make your deployments quicker since you won’t have to spend time on customisations.

To ensure our environments have a good security posture, we must regularly patch them with the latest security updates. In the cloud, you have the option of installing the updates in place or creating a new golden AMI that includes these updates and then refreshing your environments with this new golden AMI. I am a big advocate of immutable infrastructure and so always back the latter.

Most of you might be aware that AWS refreshes their AMIs frequently. The new AMIs include the latest security bug fixes at the time of release. You could then use these to create your golden AMIs.

Checking for when AWS releases a new AMI can be a daunting task, of which I am not a fan of. That is why I created a solution that would check daily if AWS had released a newer version of the AMI that I use, and then it will automatically build a new golden AMI using it. This ensured that my golden AMI was always up to date.

In this blog, I will take you through the solution I developed.  

---
Read the full blog at <https://nivleshc.wordpress.com/2022/08/22/using-aws-codepipeline-aws-codecommit-and-aws-codebuild-to-always-keep-your-golden-amis-up-to-date/>
