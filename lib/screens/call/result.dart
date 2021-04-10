import 'package:emotionly/utils/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Common _common;
  ScrollController _innerScrollController;
  ScrollController _outerScrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _common.background,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          controller: _outerScrollController,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              AppName(common: _common, fontSize: 32),

              //Start FutureBuilder here
              Column(
                children: [
                  PieChartWidget(common: _common),
                  BestEmotionWidget(common: _common),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: _common.purple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: _common.purple,
                              radius: 5,
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Angry",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "25%",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => Divider(
                        endIndent: 20,
                        color: Colors.transparent,
                        thickness: 10,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Meeting id: xyz-abc-lmn",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  DateTimeWidget(common: _common),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Participants: 12",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  ListView.separated(
                    controller: _innerScrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ClipOval(
                            child: Container(
                              height: 35,
                              width: 35,
                              child: Image.network(
                                "https://flutter.github.io/assets-for-api-docs/assets/widgets/puffin.jpg",
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Rachel Dehwi was  neutral in the meeting",
                                maxLines: 3,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: _common.purple,
                                ),
                              ),
                            ),
                          ),
                          ClipOval(
                            child: Container(
                              height: 35,
                              width: 35,
                              child: Image.network(
                                "https://flutter.github.io/assets-for-api-docs/assets/widgets/puffin.jpg",
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) => Divider(
                        color: Colors.transparent, thickness: 0, height: 20),
                    itemCount: 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _common = Common();
    _innerScrollController = ScrollController();
    _outerScrollController = ScrollController();

    _innerScrollController.addListener(
        () => _outerScrollController.jumpTo(_outerScrollController.offset));
    super.initState();
  }

  @override
  void dispose() {
    _innerScrollController.dispose();
    _outerScrollController.dispose();
    super.dispose();
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    Key key,
    @required Common common,
  })  : _common = common,
        super(key: key);

  final Common _common;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "5 April 2021",
          style: TextStyle(
            fontFamily: "Poppins",
            color: _common.blue,
            fontSize: 16,
          ),
        ),
        Text(
          "21:00:00",
          style: TextStyle(
            fontFamily: "Poppins",
            color: _common.purple,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class BestEmotionWidget extends StatelessWidget {
  const BestEmotionWidget({
    Key key,
    @required Common common,
  })  : _common = common,
        super(key: key);

  final Common _common;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 7,
          backgroundColor: _common.blue,
        ),
        SizedBox(width: 18),
        Text(
          "Happy",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 18),
        Text(
          "25%",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class PieChartWidget extends StatefulWidget {
  PieChartWidget({@required this.common});
  final common;
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: PieChart(
        PieChartData(
            pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
              setState(() {
                final desiredTouch =
                    pieTouchResponse.touchInput is! PointerExitEvent &&
                        pieTouchResponse.touchInput is! PointerUpEvent;
                if (desiredTouch && pieTouchResponse.touchedSection != null) {
                  touchedIndex =
                      pieTouchResponse.touchedSection.touchedSectionIndex;
                } else {
                  touchedIndex = -1;
                }
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: showingSections()),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      7,
      (i) {
        final isTouched = i == touchedIndex;
        final double radius = isTouched ? 60 : 50;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: widget.common.blue,
              value: 40,
              showTitle: false,
              radius: radius,
            );
          case 1:
            return PieChartSectionData(
              color: widget.common.blueLight,
              value: 10,
              showTitle: false,
              radius: radius,
            );
          case 2:
            return PieChartSectionData(
              color: widget.common.blueLighter,
              value: 10,
              showTitle: false,
              radius: radius,
            );
          case 3:
            return PieChartSectionData(
              color: widget.common.blueLightest,
              value: 10,
              showTitle: false,
              radius: radius,
            );
          case 4:
            return PieChartSectionData(
              color: widget.common.purple,
              value: 10,
              showTitle: false,
              radius: radius,
            );
          case 5:
            return PieChartSectionData(
              color: widget.common.purpleLight,
              value: 10,
              showTitle: false,
              radius: radius,
            );
          case 6:
            return PieChartSectionData(
              color: widget.common.purpleLighter,
              value: 10,
              showTitle: false,
              radius: radius,
            );
          default:
            return null;
        }
      },
    );
  }
}
