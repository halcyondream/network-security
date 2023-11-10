import requests 
import time
import sys
import traceback


API_KEY = "APIVOID-API-KEY-HERE"
API_CALL_FORMAT = "https://endpoint.apivoid.com/iprep/v1/pay-as-you-go/?key={apikey}&ip={ip}"


def get_ip_reputation_data(query_ip):
    return requests.get(API_CALL_FORMAT.format(apikey=API_KEY, ip=query_ip))


def check_reputation(api_rep_json):
    engines = api_rep_json['data']['report']['blacklists']['engines'].values()
    total_engines = len(engines)
    num_blocked = 0
    for engine in engines:
        if engine["detected"] == True:
            num_blocked += 1
    return num_blocked, total_engines


def check_ips_from_file(filename, bad_ips_only):
    with open(filename) as file:
        for line in file:
            try:
                ip_addr = line.strip()
                reputation_data = get_ip_reputation_data(ip_addr)
                blocked, total = check_reputation(reputation_data.json())
                if blocked == 0 and bad_ips_only:
                    continue
                print(f"{ip_addr} blocked by {blocked} / {total} engines.")
                time.sleep(3)   
            except Exception:
                print(traceback.format_exc())


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please specify a file with IP addresses, one per line.")
        sys.exit()
    ip_list = sys.argv[1]
    bad_ips_only = False
    if len(sys.argv) == 3:
        if sys.argv[2] == "--bad-ips":
            bad_ips_only = True
        else:
            print("Specify --bad-ips optionally.")
            sys.exit(1)
    check_ips_from_file(ip_list, bad_ips_only)
