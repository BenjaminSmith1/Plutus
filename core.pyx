import cython


cdef class FinanceCore(object):
    cdef float tax_free_allowance, lower_tax_bracket, middle_tax_bracket, upper_tax_bracket,

    def __init__(self) -> None:
        self.tax_free_allowance = 1048
        self.lower_tax_bracket = 4189
        self.middle_tax_bracket = 8333.33
        self.upper_tax_bracket = 10428.33

    cdef calculate_interest_on_value_from_rate(self, value: float, rate:float):
        """
        Calculates interest on value from rate
        :param value: float, value you want the interest to be calculated on
        :param rate: float, the prevailing interest rate.
        :return: The interest to be added to the value
        """
        return value * rate

    cdef calculate_tax_from_monthly_income(self, monthly_income: float):
        """
        Calculates tax from monthly income
        :param monthly_income: float, the monthly income
        :return: The tax to be deducted from the monthly income
        """
        # TODO: Implement pension contribution reduction
        cdef float tax = 0.0
        if monthly_income <= self.tax_free_allowance:
            return tax
        elif monthly_income <= self.lower_tax_bracket:
            tax += (monthly_income-self.tax_free_allowance) * 0.2
        elif monthly_income <= self.middle_tax_bracket:
            tax += (self.lower_tax_bracket-self.tax_free_allowance) * 0.2
            tax += (monthly_income -self.lower_tax_bracket)* 0.4
        else:
            tax += (self.lower_tax_bracket - self.tax_free_allowance) * 0.2
            tax += (monthly_income - self.lower_tax_bracket) * 0.4
            tax += monthly_income * 0.45
        return

    cdef calculate_new_tax_free_allowance(self, monthly_income: float):
        """
        Calculates the new tax free allowance
        :param monthly_income: float, the monthly income
        :return: The new tax free allowance
        """
        cdef float new_allowance
        if monthly_income >= self.upper_tax_bracket:
            new_allowance = 0
        elif monthly_income >= self.middle_tax_bracket:
            new_allowance = self.tax_free_allowance - (((monthly_income * 12) - (self.middle_tax_bracket*12)) *0.5)
        return new_allowance

    cdef calculate_national_insurance(self, monthly_income: float):
        """
        Calculates national insurance from monthly income
        :param monthly_income: float, the monthly income
        :return: the national insurance to be deducted from the monthly income
        """
        cdef float ni = 0.0
        if monthly_income <= self.tax_free_allowance:
            return ni
        elif monthly_income <= self.middle_tax_bracket:
            ni += (monthly_income - self.tax_free_allowance) * 0.08
        else:
            ni += (monthly_income - self.tax_free_allowance) * 0.08
            ni += (monthly_income - self.middle_tax_bracket) * 0.02
        return ni

    cdef calculate_pension(self, monthly_income: float, employee_contribution: float, employer_contribution:float):
        """
        Calculates the pension to be deducted from the monthly income
        :param monthly_income: float, the monthly income
        :param employee_contribution: float, the employee contribution to the pension
        :param employer_contribution: float, the employer contribution to the pension
        :return: the pension to be deducted from the monthly income
        """
        return monthly_income * (employee_contribution + employer_contribution)


