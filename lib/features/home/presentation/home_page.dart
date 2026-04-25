import 'package:datav8/core/helper/common_helper.dart';
import 'package:datav8/core/themes/custom_theme.dart';
import 'package:datav8/core/widgets/appbar_common.dart';
import 'package:datav8/features/auth/data/controller/auth_controller.dart';
import 'package:datav8/features/home/presentation/tabs/delete_old_data_tab.dart';
import 'package:datav8/features/home/presentation/tabs/set_alarms_tab.dart';
import 'package:datav8/features/home/presentation/tabs/set_hardware_configurations_tab.dart';
import 'package:datav8/features/home/presentation/tabs/view_data_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.of(context);

    return GetBuilder<AuthController>(
      builder: (ac) {
        final devices = ac.userData?.pairedDevices ?? [];
        return GestureDetector(
          onTap: () => hideKeyboard(context),
          child: Scaffold(
            appBar: appbarCommon('DataV8', hasBackButton: false, context),
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
