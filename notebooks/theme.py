# https://plotly.com/python/templates/#saving-and-distributing-custom-themes
from __future__ import annotations

import plotly.io as pio

BLACK_300 = '#e0e0e0'
BLACK_700 = '#616161'

template = pio.templates['simple_white+gridon']
axis_layout = dict(
    gridcolor=BLACK_300,
    showline=True,
    linewidth=1,
    linecolor=BLACK_700,
    mirror=True,
    titlefont=dict(size=12),
    title=dict(standoff=5),
    tickfont=dict(size=10),
)
layout = {
    'margin': dict(l=5, r=5, t=5, b=5),
    'xaxis': axis_layout,
    'yaxis': axis_layout,
    'legend': dict(
        bordercolor=BLACK_300,
        borderwidth=1,
        font=dict(size=12),
        title=dict(font=dict(size=12)),
    ),
    'title': dict(font=dict(size=12)),
    'font': dict(family='Arial'),
}
options = {
    'layout': layout,
}
template.update(options)

pio.templates['proxystore'] = template
