import numpy as np
import matplotlib.pyplot as plt
from bokeh.io import curdoc
from bokeh.layouts import column, row, layout
from bokeh.models import ColumnDataSource, Slider, TextInput
from bokeh.plotting import figure, output_file, save
from few.waveform import BicubicAmplitudeSchwarzschildEccentricFlux, EMRIInspiral

wf = BicubicAmplitudeSchwarzschildEccentricFlux()
# wf.neural_mode_selector(M, mu, p0, e0, theta, phi, T, eps)
traj = EMRIInspiral(func="SchwarzEccFlux")

def update_traj(attrname, old, new):

    # Get the current slider values
    total_mass = M.value
    co_mass = mu.value
    e0 = e.value
    p0 = p_minus_psep.value + 6 + 2*e0
    total_T = T.value 

    t, p_out, e_out, x, _, _, _ = traj(total_mass, co_mass, 0.0, p0, e0,1.0, T=total_T, dt=3.14e7 * total_T/ 100, upsample=True, fix_t=True)
    source.data = dict(p=p_out, e=e_out)

# Set up data
N = 100

Mstart = 1e6
mustart = 10
pstart = 9.4
estart = 0.2
Tstart = 4

_, ptrajstart, etrajstart, _, _, _, _ = traj(Mstart, mustart, 0.0, pstart, estart, 1.0, T=Tstart, dt = 3.14e7 * Tstart / N, upsample=True, fix_t=True)


psep = np.linspace(6, 7.4)
esep = np.linspace(0, 0.7)

sepsource = ColumnDataSource(data=dict(psep=psep, esep=esep))
source = ColumnDataSource(data=dict(p=ptrajstart, e=etrajstart))

M = Slider(start = 1e5, end = 1e7, value=Mstart, step = 1e4, title="M [Msun]")
mu = Slider(start = 1, end = 100, value=mustart, step=0.1, title=r"$\mu$")
p_minus_psep = Slider(start = 0.101, end=10, value = pstart - 6 - 2*estart, step=0.05, title=r"$p - p_\mathrm{sep}$")
e = Slider(start = 0., end=0.7, value = estart, step=0.01, title=r"$e$")
T = Slider(start = 0.01, end = 4., value = Tstart, step=0.01, title="T [yr]")

for w in [M, mu, p_minus_psep, e, T]:
    w.on_change('value', update_traj)

# trajectory
plot = figure(height=800, width=800, title="Trajectory",
              tools="crosshair,pan,reset,save,wheel_zoom",
              x_range=[6, 17.4], y_range=[0, 0.7])

plot.line('x', 'y', source=source, line_width=3, line_alpha=0.6)
plot.line('p_sep','e_sep', source = sepsource, line_width=3, line_alpha=0.6)

# Set up layouts and add to document
inputs = column(M, mu, p_minus_psep, e, T)

curdoc().add_root(row(inputs, plot, width=800))
curdoc().title = "EMRI"

output_file(filename="test_traj.html", title="Static HTML file")
save(curdoc())