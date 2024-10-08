# ssh: Secure Shell command, used to connect and operate on a remote machine securely.

# -i "~/Downloads/test-deploy.pem"

ssh -i "~/Downloads/cleber_kp.pem" -f -N -L 5432:lazzy-dev-cluster.cluster-c3a62cokqhxe.us-east-1.rds.amazonaws.com :5432 ubuntu@ec2-44-212-21-217.compute-1.amazonaws.com -v