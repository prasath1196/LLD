class Journey:
    def __init__(self):
        self.journeys = []

    def add(self, mcid, passenger_type, station_name):
        data = {
            "mcid": mcid,
            "passenger_type": passenger_type,
            "station_name": station_name,
        }
        self.journeys.append(data)
        return data

    def get_journey_count_by_mcid(self, mcid):
        count = 0
        for journey in self.journeys:
            if journey["mcid"] == mcid:
                count += 1
        return count
