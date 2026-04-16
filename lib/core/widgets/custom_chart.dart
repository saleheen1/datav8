import 'dart:math' as math;

import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/utils/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Multi-channel time series: one [LineChart] with **time (sample index) on X**
/// and **five lines** for ch1…ch5. Pass rows sorted oldest → newest.
class CustomChart extends StatefulWidget {
  const CustomChart({super.key, this.samples, this.timeLabels});

  /// Each row is `[ch1, ch2, ch3, ch4, ch5]` for one timestamp. Nulls omit points.
  final List<List<double?>>? samples;

  /// Short labels for X axis (e.g. `"13:00"`); same length as [samples].
  final List<String>? timeLabels;

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  static const _channelColors = [
    Color(0xff23b6e6),
    Color(0xff02d39a),
    Color(0xfff5a623),
    Color(0xff9b59b6),
    Color(0xffe74c3c),
  ];

  static const _channelNames = ['Ch1', 'Ch2', 'Ch3', 'Ch4', 'Ch5'];

  @override
  Widget build(BuildContext context) {
    final samples = widget.samples;
    if (samples == null || samples.isEmpty) {
      return AspectRatio(
        aspectRatio: 2,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius(5),
            color: Colors.white,
          ),
          child: Text(
            'No chart data',
            style: TextUtils.caption1(context: context),
          ),
        ),
      );
    }
    final chartHeight = _dynamicChartHeight(samples);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _legend(context),
        SizedBox(
          height: chartHeight,
          child: Container(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 16,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: radius(5),
              color: Colors.white,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final minWidthForAllLabels = (samples.length * 56).toDouble();
                final chartWidth = math.max(
                  constraints.maxWidth,
                  minWidthForAllLabels,
                );
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    child: LineChart(
                      _chartData(context, samples, widget.timeLabels),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  double _dynamicChartHeight(List<List<double?>> samples) {
    final maxValue = _yRange(samples).max.abs();
    const baseHeight = 220.0;
    const maxHeight = 420.0;
    // Grow chart height gradually as max values increase.
    final extra = (maxValue / 50) * 18;
    return (baseHeight + extra).clamp(baseHeight, maxHeight).toDouble();
  }

  Widget _legend(BuildContext context) {
    final style = TextUtils.caption1(context: context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: List.generate(5, (i) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _channelColors[i],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(_channelNames[i], style: style),
            ],
          );
        }),
      ),
    );
  }

  LineChartData _chartData(
    BuildContext context,
    List<List<double?>> samples,
    List<String>? timeLabels,
  ) {
    final n = samples.length;
    final maxX = (n - 1).toDouble();
    final lines = _lineBars(samples);
    final range = _yRange(samples);

    final yPad = range.span * 0.08;
    var minY = range.min - yPad;
    var maxY = range.max + yPad;
    if (minY >= maxY) {
      minY -= 1;
      maxY += 1;
    }

    final hInterval = (maxY - minY) > 0 ? (maxY - minY) / 4 : 1.0;
    // X is discrete sample index (0 … n−1); grid must step by 1 so lines align
    // with data points. A fractional interval (e.g. (n−1)/6) draws between points.
    const verticalGridStep = 1.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: hInterval,
        verticalInterval: verticalGridStep,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final i = value.round();
              if (i < 0 || i >= n) {
                return const SizedBox.shrink();
              }
              final style = TextUtils.caption1(
                context: context,
              ).copyWith(fontSize: 11);
              final text = (timeLabels != null && i < timeLabels.length)
                  ? timeLabels[i]
                  : '$i';
              return SideTitleWidget(
                meta: meta,
                space: 4,
                child: Text(text, style: style),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            interval: hInterval,
            minIncluded: true,
            maxIncluded: false,
            getTitlesWidget: (value, meta) {
              final style = TextUtils.caption1(context: context);
              return SideTitleWidget(
                meta: meta,
                space: 6,
                fitInside: SideTitleFitInsideData(
                  enabled: true,
                  axisPosition: meta.axisPosition,
                  parentAxisSize: meta.parentAxisSize,
                  distanceFromEdge: 2,
                ),
                child: Text(
                  value.toStringAsFixed(value.abs() >= 100 ? 0 : 1),
                  style: style,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
      ),
      minX: 0,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: lines,
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchSpotThreshold: 28,
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 12,
          getTooltipColor: (_) => Colors.black87,
          getTooltipItems: (spots) {
            if (spots.isEmpty) return const [];
            final style = TextUtils.caption1(
              context: context,
            ).copyWith(color: Colors.white);
            return spots.map((s) {
              final ch = _channelColors.indexWhere((c) => c == s.bar.color);
              final name = ch >= 0 && ch < _channelNames.length
                  ? _channelNames[ch]
                  : 'Ch?';
              return LineTooltipItem('$name: ${s.y.toStringAsFixed(2)}', style);
            }).toList();
          },
        ),
      ),
    );
  }

  List<LineChartBarData> _lineBars(List<List<double?>> samples) {
    final n = samples.length;
    final showDots = n <= 20;
    const drawOrder = [1, 2, 3, 4, 0];
    return drawOrder
        .map((ch) {
          final spots = <FlSpot>[];
          for (var i = 0; i < n; i++) {
            final row = samples[i];
            if (ch >= row.length) continue;
            final y = row[ch];
            if (y != null) spots.add(FlSpot(i.toDouble(), y));
          }
          return LineChartBarData(
            spots: spots,
            color: _channelColors[ch],
            isCurved: true,
            curveSmoothness: 0.35,
            barWidth: ch == 0 ? 3.2 : 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: showDots,
              getDotPainter: (spot, percent, bar, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: _channelColors[ch],
                  strokeWidth: 1.2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          );
        })
        .where((b) => b.spots.isNotEmpty)
        .toList();
  }

  _YRange _yRange(List<List<double?>> samples) {
    double? minV;
    double? maxV;
    for (final row in samples) {
      for (final v in row) {
        if (v == null) continue;
        minV = minV == null ? v : math.min(minV, v);
        maxV = maxV == null ? v : math.max(maxV, v);
      }
    }
    if (minV == null || maxV == null) {
      return const _YRange(0, 1);
    }
    return _YRange(minV, maxV);
  }
}

class _YRange {
  const _YRange(this.min, this.max);
  final double min;
  final double max;
  double get span => max - min;
}
