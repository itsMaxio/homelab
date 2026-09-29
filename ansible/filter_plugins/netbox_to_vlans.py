def netbox_to_vlans(interfaces: list[dict]) -> list[dict]:
    if not interfaces:
        return []

    final_vlans: dict = {}

    for interface in interfaces:
        vlans_to_check = []

        untagged_vlan = interface.get("untagged_vlan")
        if untagged_vlan:
            vlans_to_check.append(untagged_vlan)

        tagged_vlan = interface.get("tagged_vlans")
        if tagged_vlan:
            vlans_to_check.extend(tagged_vlan)

        for vlan in vlans_to_check:
            vlan_id = vlan.get("vid")
            if vlan_id is not None and vlan_id not in final_vlans:
                final_vlans[vlan_id] = {
                    "vlan_id": vlan_id,
                    "name": vlan.get("name", ""),
                    "state": "active",
                    "shutdown": "disabled",
                }

    return list(final_vlans.values())

class FilterModule:
    def filters(self):
        return {
            "netbox_to_vlans": netbox_to_vlans,
        }