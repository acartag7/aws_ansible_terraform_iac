#DNS CONFIGURATION
#Get already, publicly configured hosted zone on route53 - MUST Exist
data "aws_route53_zone" "dns" {
    provider = aws.region-master
    name = var.dns-name
}

#Create Record in hosted zone for ACM Certificate Domain Verification
resource "aws_route53_record" "cert_validation" {
    provider = aws.region-master
    for_each = {
        for val in aws_acm_certificate.frontend-lb-https.domain_validation_options : val.domain_name => {
            name = val.resource_record_name
            record = val.resource_record_value
            type = val.resource_record_type
        }
    }
    name = each.value.name
    records = [each.vaule.record]
    ttl = 60
    type = each.value.type
    zone_id = data.aws_route53_zone.dns.zone_id
}