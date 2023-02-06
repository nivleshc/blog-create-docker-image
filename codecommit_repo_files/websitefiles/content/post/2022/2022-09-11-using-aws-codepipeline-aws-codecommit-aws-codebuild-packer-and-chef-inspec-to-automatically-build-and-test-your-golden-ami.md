---
title: "Using Aws Codepipeline Aws Codecommit Aws Codebuild Packer and Chef Inspec to Automatically Build and Test Your Golden AMI"
date: 2023-02-05T07:49:31Z
tags: [aws]
draft: false
---

# Introduction
Whenever you use automation pipelines, it is imperative that you incorporate a testing stage. This will provide confidence that the deliverables from pipeline align to your requirements.

Testing plays a key role when building golden AMIs for the simple reason that if you build an image, you must have confidence that it is ready to be deployed in an environment. Let me unpack this point a bit more. When you are building a golden AMI, you will be adding more packages to the base AMI and also customising it to suit your requirements. You need to have absolute certainty that all the packages that you intended to install have actually been deployed and the configuration changes have actually taken effect. You do not want to be in a situation where your deployment pipeline fails because a critical package is missing from the golden AMI. A possible cause could be that during the build of that golden AMI, the package wasn’t installed due to connectivity issues with the package repository!

Using the golden AMI pipeline that was discussed in my previous blog, I will walk you through the process of adding a testing stage to it, to ensure that the golden AMIs that are being built, have all the packages that it is meant to have.

If you haven’t read the previous blog (or need a refresher), please read it before continuing. Here is the link to it https://nivleshc.wordpress.com/2022/08/22/using-aws-codepipeline-aws-codecommit-and-aws-codebuild-to-always-keep-your-golden-amis-up-to-date/

Let’s get started.  

---
Read the full blog at <https://nivleshc.wordpress.com/2022/09/11/using-aws-codepipeline-aws-codecommit-aws-codebuild-packer-and-chef-inspec-to-automatically-build-and-test-your-golden-ami/>
