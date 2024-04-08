import cython


cdef class FinanceCore:

    def __init__(self) -> None:
        pass

    def calculate_interest_from_rate(self, prelim_value: float, rate:float):
        return prelim_value * rate
