class MetroCard:
    def __init__(self):
        self.cardList = {}

    def add_card(self, mcid, balance):
        self.cardList[mcid] = {"balance": balance}

    def recharge(self, mcid, amount):
        if mcid in self.cardList:
            self.cardList[mcid]["balance"] += amount
        else:
            raise ValueError("Invalid Card")

    def get_balance(self, mcid):
        if mcid in self.cardList:
            return self.cardList[mcid]["balance"]
        else:
            raise ValueError("Invalid Card")

    def deduct_balance(self, mcid, amount):
        if mcid in self.cardList:
            self.cardList[mcid]["balance"] -= amount
        else:
            raise ValueError("Invalid Card")
