import 'package:datav8/core/helper/common_helper.dart';
import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/utils/text_utils.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/features/auth/data/controller/auth_controller.dart';
import 'package:datav8/features/home/data/controller/delete_old_data_controller.dart';
import 'package:datav8/features/home/data/controller/set_alarms_controller.dart';
import 'package:datav8/features/home/data/controller/set_hardware_configurations_controller.dart';
import 'package:datav8/features/home/data/controller/set_hardware_sensor_dropdown_controller.dart';
import 'package:datav8/features/home/presentation/tabs/delete_old_data_tab.dart';
import 'package:datav8/features/home/presentation/tabs/set_alarms_tab.dart';
import 'package:datav8/features/home/presentation/tabs/set_hardware_configurations_tab.dart';
import 'package:datav8/features/home/presentation/tabs/view_data_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final sensorDropdownController =
        Get.find<SetHardwareSensorDropdownController>();
    final setAlarmsController = Get.find<SetAlarmsController>();
    final setHardwareConfigController =
        Get.find<SetHardwareConfigurationsController>();
    final deleteOldDataController = Get.find<DeleteOldDataController>();

    sensorDropdownController.initializeForHome();
    setAlarmsController.initializeForHome();
    setHardwareConfigController.initializeForHome();
    deleteOldDataController.initializeForHome();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);

    return GetBuilder<AuthController>(
      builder: (ac) {
        final devices = ac.userData?.pairedDevices ?? [];
        return GestureDetector(
          onTap: () => hideKeyboard(context),
          child: Scaffold(
            appBar: appbarCommon(
              'DataV8',
              hasBackButton: false,
              context,
              actions: [
                TextButton(
                  onPressed: () async {
                    await ac.logout();
                  },
                  child: Text(
                    'Logout',
                    style: TextUtils.b1SemiBold(
                      context: context,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              color: theme.greyBg,
              margin: EdgeInsets.only(bottom: 50),
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: theme.primary,
                        indicatorColor: theme.primary,
                        tabs: const [
                          Tab(text: 'View data'),
                          Tab(text: 'Set alarms'),
                          Tab(text: 'Logger setup'),
                          Tab(text: 'Clear old data'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ViewDataTab(devices: devices),
                          const SetAlarmsTab(),
                          const SetHardwareConfigurationsTab(),
                          const DeleteOldDataTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
