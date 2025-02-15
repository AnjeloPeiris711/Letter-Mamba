import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportDashboardScreen extends StatelessWidget {
  final double percentage;
  final String description;
  final Color progressColor;
  final Color backgroundColor;

  const ReportDashboardScreen(
      {required this.percentage,
      required this.description,
      this.progressColor = const Color(0xFF3B82F6), // Blue color
      this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Report Section',
                style: GoogleFonts.irishGrover(
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 24),
              // Progress Indicator
              Container(
                height: 220, // Ensure container height is enough
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 247, 247, 247),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 212, 212, 212),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Speedometer Gauge (Above the Text)
                    Positioned(
                      top: 0, // Align to top
                      child: SizedBox(
                        height: 200, // Adjust height for gauge
                        width: 200,
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: 100,
                              startAngle: 160,
                              endAngle: 20,
                              showLabels: false,
                              showTicks: false,
                              radiusFactor: 0.2, // Fit to container
                              axisLineStyle: const AxisLineStyle(
                                thickness: 25,
                                color: Color.fromARGB(255, 196, 215, 233),
                                thicknessUnit: GaugeSizeUnit.logicalPixel,
                              ),
                            ),
                            RadialAxis(
                              minimum: 0,
                              maximum: 100,
                              startAngle: 160,
                              endAngle: 20,
                              showLabels: false,
                              showTicks: false,
                              radiusFactor: 1.0, // Fit to container
                              axisLineStyle: const AxisLineStyle(
                                thickness: 30,
                                color: Color.fromARGB(255, 196, 215, 233),
                                thicknessUnit: GaugeSizeUnit.logicalPixel,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  value: 82,
                                  width: 30,
                                  color: Colors.blue,
                                  enableAnimation: true,
                                  cornerStyle: CornerStyle.bothFlat,
                                ),
                                NeedlePointer(
                                  value: 82,
                                  needleLength: 0.7,
                                  needleStartWidth: 1,
                                  needleEndWidth: 5,
                                  knobStyle: KnobStyle(
                                    borderColor: Colors.black,
                                    borderWidth: 0.05,
                                    knobRadius: 0.08,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  enableAnimation: true,
                                  animationType: AnimationType.ease,
                                  animationDuration: 1000,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Text Below the Speedometer (Lower Z-Index)
                    Positioned(
                      bottom: 5, // Push text below the gauge
                      child: Column(
                        children: [
                          const Text(
                            'You Completed 82% of your target',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Orders this week than last week',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    icon: Icons.person,
                    value: '855',
                    label: 'Total Visitors',
                    change: '+4.8%',
                    isPositive: true,
                  ),
                  _buildStatCard(
                    icon: Icons.shopping_basket,
                    value: '658',
                    label: 'Total Orders',
                    change: '+2.5%',
                    isPositive: true,
                  ),
                  _buildStatCard(
                    icon: Icons.visibility,
                    value: '788',
                    label: 'Total Views',
                    change: '-1.5%',
                    isPositive: false,
                  ),
                  _buildStatCard(
                    icon: Icons.chat,
                    value: '82%',
                    label: 'Conversation',
                    change: '+2.0%',
                    isPositive: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Overview Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          _buildTimeButton('Today', true),
                          _buildTimeButton('Weekly', false),
                          _buildTimeButton('Monthly', false),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 60,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = [
                                  'Sun',
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat'
                                ];
                                return Text(
                                  days[value.toInt()],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '\$${value.toInt()}K',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          _createBarGroup(0, 45, 35),
                          _createBarGroup(1, 40, 45),
                          _createBarGroup(2, 35, 32),
                          _createBarGroup(3, 42, 38),
                          _createBarGroup(4, 48, 42),
                          _createBarGroup(5, 42, 35),
                          _createBarGroup(6, 38, 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Generate Report Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 204, 204, 204),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'generate report',
                    style: GoogleFonts.irishGrover(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required String change,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 247, 247),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 212, 212, 212),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.blue),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.grey[200] : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  BarChartGroupData _createBarGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.blue,
          width: 8,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.blue[200],
          width: 8,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}
