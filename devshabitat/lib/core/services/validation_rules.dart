import 'package:http/http.dart' as http;

class ProfileValidation {
  static String? validateDisplayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'İsim gereklidir';
    }
    if (value.trim().length < 2) {
      return 'İsim en az 2 karakter olmalıdır';
    }
    if (value.trim().length > 50) {
      return 'İsim en fazla 50 karakter olabilir';
    }
    return null;
  }

  static String? validateBio(String? value) {
    if (value != null && value.length > 500) {
      return 'Biyografi en fazla 500 karakter olabilir';
    }
    if (value != null && value.length < 10) {
      return 'Biyografi en az 10 karakter olmalıdır';
    }
    return null;
  }

  static String? validateCurrentRole(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length < 2) {
        return 'Rol en az 2 karakter olmalıdır';
      }
      if (value.trim().length > 100) {
        return 'Rol en fazla 100 karakter olabilir';
      }
    }
    return null;
  }

  static String? validateCompany(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length < 2) {
        return 'Şirket adı en az 2 karakter olmalıdır';
      }
      if (value.trim().length > 100) {
        return 'Şirket adı en fazla 100 karakter olabilir';
      }
    }
    return null;
  }

  static String? validateSkills(List<String> skills) {
    if (skills.length < 3) {
      return 'En az 3 beceri seçmelisiniz';
    }
    if (skills.length > 20) {
      return 'En fazla 20 beceri seçebilirsiniz';
    }
    return null;
  }

  static Future<String?> validateGitHubUsername(String? value) async {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    // Basic format validation
    if (!RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9]|-)*[a-zA-Z0-9]$').hasMatch(value)) {
      return 'Geçersiz GitHub kullanıcı adı formatı';
    }

    // GitHub API validation
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/users/$value'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 404) {
        return 'GitHub kullanıcısı bulunamadı';
      }
      if (response.statusCode != 200) {
        return 'GitHub kullanıcısı doğrulanamadı';
      }
      return null;
    } catch (e) {
      return 'GitHub bağlantı hatası';
    }
  }

  static String? validateSocialUrl(String? value, String platform) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final url = value.trim();
    final Map<String, String> patterns = {
      'linkedin': r'https?://(www\.)?linkedin\.com/in/[a-zA-Z0-9-]+/?',
      'twitter': r'https?://(www\.)?twitter\.com/[a-zA-Z0-9_]+/?',
      'website': r'https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/?.*',
    };

    if (patterns.containsKey(platform.toLowerCase())) {
      if (!RegExp(patterns[platform.toLowerCase()]!).hasMatch(url)) {
        return '$platform URL formatı geçersiz';
      }
    }

    return null;
  }

  static String? validateProjectTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Proje başlığı gereklidir';
    }
    if (value.trim().length < 3) {
      return 'Proje başlığı en az 3 karakter olmalıdır';
    }
    if (value.trim().length > 100) {
      return 'Proje başlığı en fazla 100 karakter olabilir';
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
