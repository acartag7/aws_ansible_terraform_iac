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
  value = {
      for instance in aws_instance.jenkins-worker-instance :
      "${lookup(aws_instance.jenkins-worker-instance.tags)}" => instance.public_ip
}