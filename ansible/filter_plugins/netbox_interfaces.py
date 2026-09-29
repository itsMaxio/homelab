final_interfaces: list = []

def netbox_to_l1(interfaces: list[dict]) -> list[dict]:
    if not interfaces:
        return []

    for interface in interfaces:
        entry: dict = {}

        name = interface.get("name")
        if not name:
            continue
        entry["name"] = name
        
        entry["enabled"] = bool(interface.get("enabled"))

        description = str(interface.get("description") or "").strip()
        if description:
            entry["description"] = description


        mtu = interface.get("mtu")
        if mtu:
            entry["mtu"] = int(mtu)
        
        final_interfaces.append(entry)
    return final_interfaces

def netbox_to_l2(interfaces: list[dict]) -> list[dict]:
    if not interfaces:
        return []

    for interface in interfaces:
        if (interface.get("type") or {}).get("value") == "virtual":
            continue

        mode = (interface.get("mode") or {}).get("value")

        if mode not in ["access", "tagged"]:
            continue

        entry = {
            "name": interface.get("name")
        }

        if mode == "access":
            entry["mode"] = "access"
            untagged_vlan = interface.get("untagged_vlan")
            if untagged_vlan  and untagged_vlan.get("vid"):
                entry["access"] = {
                    "vlan": untagged_vlan.get("vid")
                }

        elif mode == "tagged":
            entry["mode"] = "trunk"
            trunk_config = {
                "encapsulation": "dot1q"
            }

            untagged_vlan = interface.get("untagged_vlan")
            if untagged_vlan and untagged_vlan.get("vid"):
                trunk_config["native_vlan"] = untagged_vlan.get("vid")

            tagged_vlans = interface.get("tagged_vlans") or []
            if tagged_vlans and len(tagged_vlans) > 0:
                vlan_ids = [
                    str(tagged_vlan.get("vid")) 
                    for tagged_vlan in tagged_vlans 
                    if tagged_vlan.get("vid") is not None
                ]
                if vlan_ids:
                    trunk_config["allowed_vlans"] = ",".join(vlan_ids)

            entry["trunk"] = trunk_config

        final_interfaces.append(entry)

    return final_interfaces

from pprint import pprint

def netbox_to_l3(interfaces: list[dict]) -> list[dict]:
    if not interfaces:
        return []

    for interface in interfaces:
        if (interface.get("type") or {}).get("value") != "virtual":
            continue

        ip_entries = interface.get("ip_addresses") or []
        if not ip_entries:
            continue

        name = interface.get("name")

        primaries: dict[int, dict] = {}
        secondaries: dict[int, list[dict]] = {4: [], 6: []}

        for ip_entry in ip_entries:
            family = (ip_entry.get("family") or {}).get("value")
            if family not in (4, 6):
                continue

            address = ip_entry.get("address")
            role = (ip_entry.get("role") or {}).get("value")

            ip = {"address": address}

            if role is None:
                primaries[family] = ip
            elif role == "secondary":
                ip["secondary"] = True
                secondaries[family].append(ip)

        interface_data = {
            "name": name,
            "autostate": True,
        }

        ipv4_list = ([primaries[4]] if 4 in primaries else []) + secondaries[4]
        ipv6_list = ([primaries[6]] if 6 in primaries else []) + secondaries[6]

        if ipv4_list:
            interface_data["ipv4"] = ipv4_list
        if ipv6_list:
            interface_data["ipv6"] = ipv6_list

        final_interfaces.append(interface_data)
    return final_interfaces


class FilterModule():
    def filters(self):
        return {
            "netbox_to_l1": netbox_to_l1,
            "netbox_to_l2": netbox_to_l2,
            "netbox_to_l3": netbox_to_l3
        }