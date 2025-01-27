class QrCodeFormats{
  static String formatWifiBarcode(String rawValue) {
    if (!rawValue.startsWith('WIFI:')) {
      return 'Invalid WIFI format';
    }

    // Remove 'WIFI:' prefix from the raw value
    rawValue = rawValue.substring(5);

    // Split the raw value by ';' to get the key-value pairs
    final parts = rawValue.split(';');

    // Initialize variables for each field
    String? type, ssid, password, hidden;

    // Loop through each part and assign values to respective fields
    for (var part in parts) {
      if (part.startsWith('T:')) {
        type = part.substring(2);
      } else if (part.startsWith('S:')) {
        ssid = part.substring(2);
      } else if (part.startsWith('P:')) {
        password = part.substring(2);
      } else if (part.startsWith('H:')) {
        hidden = part.length > 2
            ? part.substring(2)
            : "No"; // If H: is empty, treat it as "No"
      }
    }

    // Return the formatted WiFi details
    return 'WiFi Network:\nType: $type\nSSID: $ssid\nPassword: $password\nHidden: $hidden';
  }

  static String formatVCard(String rawValue) {
    final lines = rawValue.split('\n');
    final Map<String, dynamic> vCardData = {};
    final Map<String, String> phoneNumbers =
    {}; // To map type (e.g., Mobile, Fax) with numbers

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length > 1) {
        final key =
        parts[0].split(';')[0].trim(); // Handle keys like TEL;WORK;VOICE
        final value = parts.sublist(1).join(':').trim();

        if (key == 'N') {
          vCardData['Name'] = value.replaceAll(';', ' ');
        } else if (key == 'FN') {
          vCardData['Full Name'] = value; // Store full name
        } else if (key == 'ORG') {
          vCardData['Organization'] = value;
        } else if (key == 'TITLE') {
          vCardData['Title'] = value;
        } else if (key == 'ADR') {
          // Split the address components and remove any empty ones
          List<String> addressParts = value.split(';');
          addressParts = addressParts
              .where((part) => part.isNotEmpty)
              .toList(); // Filter out empty parts
          vCardData['Address'] =
              addressParts.join(', '); // Join the non-empty parts with commas
        } else if (key == 'TEL') {
          final type = parts[0].contains(';')
              ? parts[0]
              .split(';')[1]
              .toUpperCase() // Extract the type (e.g., WORK, FAX)
              : 'Unknown';
          phoneNumbers[type] = value; // Add to phone numbers map
        } else if (key == 'EMAIL') {
          vCardData['Email'] = value;
        } else if (key == 'URL') {
          vCardData['Website'] = value;
        }
      }
    }

    // Add phone numbers to the vCard data
    phoneNumbers.forEach((type, number) {
      vCardData['$type Phone'] = number;
    });

    // Format the fields for display, starting with Full Name at the top
    final buffer = StringBuffer();

    // Check and append Full Name first
    if (vCardData.containsKey('Full Name')) {
      buffer.writeln(vCardData['Full Name']);
    }

    // Then append the rest of the details
    vCardData.forEach((key, value) {
      if (key != 'Full Name') {
        buffer.writeln(value); // Append only the value, without the keys
      }
    });

    return buffer.toString().trim(); // Return formatted string
  }

  static String formatEmail(String rawValue) {
    // Check if the rawValue starts with 'MATMSG:'
    if (!rawValue.startsWith('MATMSG:')) {
      return 'Invalid MATMSG format';
    }

    // Remove 'MATMSG:' prefix from the raw value
    rawValue = rawValue.substring(7);

    // Split the raw value by semicolons to get individual components
    final parts = rawValue.split(';');

    // Initialize variables to store extracted values
    String to = '';
    String subject = '';
    String body = '';

    // Loop through the parts and extract the necessary details
    for (var part in parts) {
      if (part.startsWith('TO:')) {
        to = part.substring(3); // Extract the recipient email address
      } else if (part.startsWith('SUB:')) {
        subject = part.substring(4); // Extract the subject
      } else if (part.startsWith('BODY:')) {
        body = part.substring(5); // Extract the body text
      }
    }

    // Log the parsed values for debugging
    print('Parsed Email: TO=$to, SUBJECT=$subject, BODY=$body');

    // Return the formatted email message
    return '$to\n$subject\n$body';
  }

  static String formatSMS(String rawValue) {
    // Check if the rawValue starts with 'SMSTO:'
    if (!rawValue.startsWith('SMSTO:')) {
      return 'Invalid SMSTO format';
    }

    // Remove 'SMSTO:' prefix from the raw value
    rawValue = rawValue.substring(6);

    // Split the raw value by the first colon to get the phone number and message
    final parts = rawValue.split(':');

    // Ensure there are two parts (phone number and message)
    if (parts.length != 2) {
      return 'Invalid SMS format';
    }

    final phoneNumber = parts[0]; // First part: phone number
    final message = parts[1]; // Second part: message

    // Return the formatted SMS message
    return '$phoneNumber\n$message';
  }
}