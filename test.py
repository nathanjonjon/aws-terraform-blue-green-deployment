import unittest
## feel free to make your own test case for your app
class toy_unittest(unittest.TestCase):
    def helloworld(self):
        self.assertTrue('hello' == 'hello')

if __name__ == "__main__":
    unittest.main()
    print('test pass')

