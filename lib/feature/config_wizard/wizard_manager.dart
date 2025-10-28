import 'package:launchpad_binder/entity/interface/manager_base.dart';
import 'package:launchpad_binder/entity/mixin/condition_exception_handler.dart';
import 'package:launchpad_binder/entity/mixin/logger_mixin.dart';
import 'package:launchpad_binder/entity/mixin/snackbar_mixin.dart';
import 'package:launchpad_binder/feature/config_wizard/wizard_state.dart';

class WizardManager extends ManagerBase<WizardState>
    with CEHandler, SnackbarMixin, LoggerMixin {
  WizardManager(super.state, {required super.deps});
}
