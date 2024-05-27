# Bank Churners ML Flow 

## 📒 Description
This project is an exercise on deploying ML Flow to track and monitor a model created by a colleague, [CoVictor](https://github.com/CoViktor/customer_churn_analysis/blob/main/Classification/Rand_forest.ipynb), as part of a student exercise at [BeCode](https://becode.org/).

It aims to deploy ML Flow in AWS Cloud using Terraform.

##  📦 Repo Structure 
```
├── terraform-setup/
│   ├── providers.tf
│   ├── s3.tf
│   ├── rds.tf
│   ├── security_groups.tf
│   ├── iam.tf
│   ├── ec2.tf
│   ├── outputs.tf
│   └── user_data.sh.tpl
├── assets/
│   ├── Rand_forest.ipynb (from CoVictor)
│   └── Screenshot-mlflow.png
├── data/
│   └── BankChurners.csv
├── mlflow-experiment.py
├── requirements.txt
└── README.md
```


## 🛠 Pre-requisites
This project requires **MLFlow** and **Terraform** to be installed and running.

## ML Flow
![](assets/Screenshot-mlflow.png)

## 🕐 Timeline

This project was created in 8 days.