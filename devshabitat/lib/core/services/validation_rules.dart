import 'package:http/http.dart' as http;

class ProfileValidation {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Name cannot exceed 50 characters';
    }
    return null;
  }

  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 10) {
      return 'Bio must be at least 10 characters';
    }
    return null;
  }

  static String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 2) {
      return 'Role must be at least 2 characters';
    }
    return null;
  }

  static String? validateCompany(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 2) {
      return 'Company name must be at least 2 characters';
    }
    if (value.length > 100) {
      return 'Company name cannot exceed 100 characters';
    }
    return null;
  }

  static String? validateSkills(List<String> skills) {
    if (skills.isEmpty) {
      return 'Please select at least 3 skills';
    }
    if (skills.length > 20) {
      return 'You can select up to 20 skills';
    }
    return null;
  }

  static String? validateGitHubUsername(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final regex = RegExp(r'^[a-z\d](?:[a-z\d]|-(?=[a-z\d])){0,38}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid GitHub username format';
    }
    return null;
  }

  static Future<String?> validateGitHubUser(String username) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/users/$username'),
      );
      if (response.statusCode == 404) {
        return 'GitHub user not found';
      }
      if (response.statusCode != 200) {
        return 'Could not verify GitHub user';
      }
      return null;
    } catch (e) {
      return 'GitHub connection error';
    }
  }

  static String? validateSocialLink(String? value, String platform) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'Invalid $platform URL format';
      }
      return null;
    } catch (e) {
      return 'Invalid $platform URL format';
    }
  }

  static String? validateProjectTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Project title is required';
    }
    if (value.length < 3) {
      return 'Project title must be at least 3 characters';
    }
    if (value.length > 100) {
      return 'Project title cannot exceed 100 characters';
    }
    return null;
  }

  static String? validateProjectDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Project description is required';
    }
    if (value.trim().length < 20) {
      return 'Project description must be at least 20 characters';
    }
    if (value.trim().length > 500) {
      return 'Project description cannot exceed 500 characters';
    }
    return null;
  }
}
