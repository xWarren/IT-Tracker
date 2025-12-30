import 'package:flutter/services.dart';

class InputFormatters {
  static final email = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$")),
  ];

  static final password = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r"[ -~]")),
    FilteringTextInputFormatter.deny(RegExp(r"\s")),
  ];

  static final name = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'\-]")),
  ];

  static final address = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s,.\-#/]")),
  ];

  static final contactPhone = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(11)
  ];
}
