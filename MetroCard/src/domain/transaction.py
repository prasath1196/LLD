class Transaction:
    def __init__(self, metro_cards):
        self.data = []
        self.mcid_counter = {}
        self.metro_cards = metro_cards

    def add_jouney_transaction(self, breakdown):
        self.data.append(breakdown)

    def summary_data(self):
        result = {}
        for t in self.data:
            station_name = t["station_name"]

            if station_name not in result:
                result[station_name] = {
                    "total_collection": 0,
                    "total_discount": 0,
                    "passenger_count": {},
                }

            result[station_name]["total_collection"] += t["net_fare"]
            result[station_name]["total_discount"] += t["discount_amount"]
            p_type = t["passenger_type"]
            result[station_name]["passenger_count"][p_type] = (
                result[station_name]["passenger_count"].get(p_type, 0) + 1
            )
        return result

    def summary_text(self):
        return self.format_summary(self.summary_data())

    def summary(self):
        """
        Backwards-compatible behavior for the CLI path: print the summary.
        Returns the formatted summary text.
        """
        output = self.summary_text()
        print(output.rstrip("\n"))
        return output

    def format_summary(self, result):
        output = ""
        # Order stations: CENTRAL first, then AIRPORT
        sorted_stations = []
        if "CENTRAL" in result:
            sorted_stations.append("CENTRAL")
        if "AIRPORT" in result:
            sorted_stations.append("AIRPORT")

        for i, station in enumerate(sorted_stations):
            s = result[station]

            passenger_str = "PASSENGER_TYPE_SUMMARY\n"

            sorted_passengers = sorted(
                s["passenger_count"].items(), key=lambda x: (-x[1], x[0])
            )

            for p_type, count in sorted_passengers:
                if count > 0:
                    passenger_str += f"{p_type} {count}\n"

            # Format station name with proper spacing
            if station == "AIRPORT":
                station_name = (
                    f"TOTAL_COLLECTION {station}  "  # Two spaces after AIRPORT
                )
            else:
                station_name = f"TOTAL_COLLECTION {station} "  # One space after CENTRAL

            station_output = (
                f"{station_name}"
                f"{round(s['total_collection'])} "
                f"{round(s['total_discount'])} \n"  # Space at end
                f"{passenger_str}"
            )

            output += station_output

        return output
