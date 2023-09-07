"""
tests
"""
from django.test import SimpleTestCase
from app import calc


class CalcTests(SimpleTestCase):
    """ test calc module """

    def test_add_numbers(self):
        res = calc.add(5, 6)

        self.assertEquals(res, 11)

    def test_substract_numbers(self):
        res = calc.sub(6, 3)

        self.assertEquals(res, 3)
