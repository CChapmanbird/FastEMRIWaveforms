import unittest
from few.summation.interpolatedmodesum import CubicSplineInterpolant

class GPUAvailableTest(unittest.TestCase):
    def test_cupy_available(self):
        import cupy as cp
        test_arr = cp.ones(5)
        test_arr * test_arr
        test_arr.get()

    def test_gpu_available(self):
        # try to run the GPU cubic spline interpolant and see if it runs
        import cupy as cp
        time = cp.linspace(0., 10., 100)
        data = cp.random.normal(size=time.size)
        time_check = cp.random.uniform(0. ,10., 1000)
        spl = CubicSplineInterpolant(time, data, use_gpu=True)
        spl(time_check).get()