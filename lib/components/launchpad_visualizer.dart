import 'package:flutter/material.dart';
import 'package:launchpad_binder/entity/enum/profile_pad.dart';

class LaunchpadVisualizer extends StatelessWidget {
  final ProfilePad? highlightedPad; // какую кнопку подсвечивать
  final VoidCallback?
  onProfilePadTap; // опционально: для симуляции нажатия в UI

  const LaunchpadVisualizer({
    super.key,
    this.highlightedPad,
    this.onProfilePadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 8 рядов: основная сетка (8 кнопок) + 1 кнопка профиля справа
        for (int row = 0; row < 8; row++)
          Row(
            children: [
              // Основная сетка 8x8 (серые кнопки, неактивные на этом этапе)
              for (int col = 0; col < 8; col++)
                _buildPad(context, isProfile: false),

              // Кнопка профиля справа
              const SizedBox(width: 12),
              _buildProfilePad(
                context,
                pad: ProfilePad.values[row],
                isHighlighted: highlightedPad == ProfilePad.values[row],
                onTap: onProfilePadTap,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPad(BuildContext context, {required bool isProfile}) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isProfile
            ? Colors.grey[800]
            : const Color.fromARGB(255, 182, 182, 182),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black, width: 1),
      ),
    );
  }

  Widget _buildProfilePad(
    BuildContext context, {
    required ProfilePad pad,
    required bool isHighlighted,
    VoidCallback? onTap,
  }) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.blueAccent : Color.fromARGB(255, 182, 182, 182),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: Colors.black,
            width: isHighlighted ? 2 : 1,
          ),
        ),
        child: Center(),
      ),
    );
  }
}
