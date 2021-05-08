output "Jenkins-Master-Node-Public-IP" {
  value = aws_instance.jenkins-master-instance.public_ip
}

#output "Jenkins-Worker-Node-Public-IP" {
#  value = {
#    for instance in aws_instance.jenkins-worker-instance :
#    instance.id => instance.public_ip
#  }
#}


output "Jenkins-Worker-Node-Public-IP" {
  value = aws_instance.jenkins-worker-instance.*.tags => aws_instance.jenkins-worker-instance.*.public_ip
}