#!/usr/bin/env python3
import dns.resolver

def query_dns_records(domain_name):
    all_records = {}
 
    a_records = query_dns_by_record_type(domain_name, 'A')
    if len(a_records) > 0:
        all_records['A'] = a_records

    aaaa_records = query_dns_by_record_type(domain_name, 'AAAA')
    if len(aaaa_records) > 0:
        all_records['AAAA'] = aaaa_records

    mx_records = query_dns_by_record_type(domain_name, 'MX')
    if len(mx_records) > 0:
        all_records['MX'] = mx_records

    ns_records = query_dns_by_record_type(domain_name, 'NS')
    if len(ns_records) > 0:
        all_records['NS'] = ns_records

    txt_records = query_dns_by_record_type(domain_name, 'TXT')
    if len(txt_records) > 0:
        all_records['TXT'] = txt_records

    soa_records = query_dns_by_record_type(domain_name, 'SOA')
    if len(soa_records) > 0:
        all_records['SOA'] = soa_records

    return all_records

def query_dns_by_record_type(domain_name, record_type):
    resolver = dns.resolver.Resolver()
    records = []
    try:
        answers = resolver.resolve(domain_name, record_type)
        for a in answers:
            records.append(a)
        return records
    except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN, dns.resolver.NoNameservers):
        return records

if __name__ == "__main__":
    import sys
    domain_name = sys.argv[1]
    results = query_dns_records(domain_name)
    for record_type, response_text in results.items():
        print(f"\n{record_type} Records:")
        print(response_text)
    print("\nResults dictionary:", results)
