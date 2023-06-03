class AppConstants {
  // Intro Page 1
  static const String introPage1Title = "Welcome to Synergy";
  static const String introPage1Description =
      "Step into a world where connections thrive and collaboration knows no bounds. Join Synergy, the social sharing platform that empowers you to unite, share your passions, and amplify your impact. Together, let's create a community where strength lies in our shared experiences.";
  static const String introPage1Lottie =
      "https://assets8.lottiefiles.com/packages/lf20_AMBEWz.json";

  // Intro Page 2
  static const String introPage2Title = "Discover a World of Possibilities";
  static const String introPage2Description =
      "Unlock a realm of endless possibilities with Synergy. Immerse yourself in a vibrant network of like-minded individuals and diverse communities. Explore captivating content, ignite inspiring conversations, and unleash your potential as you embark on a journey of collaboration, growth, and shared achievements.";
  static const String introPage2Lottie =
      "https://assets7.lottiefiles.com/packages/lf20_nSCNoR4RN0.json";

  // Intro Page 3
  static const String introPage3Title = "Building Bridges, Forging Connections";
  static const String introPage3Description =
      "Synergy bridges the gaps between individuals, forging meaningful connections that transcend borders, cultures, and backgrounds. Experience the transformative power of connecting with others who share your vision, values, and passions. Together, let's build a global community that celebrates unity, diversity, and the strength we find in coming together.";
  static const String introPage3Lottie =
      "https://assets5.lottiefiles.com/packages/lf20_9ti102vm.json";

  static const String appTitle = 'S y n e r g y';
  static const String appSubtitle =
      'Uniting individuals, amplifying connections, and unleashing the power of collective collaboration.';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';

  // Login page strings
  static const String loginRememberMe = 'Remember me';
  static const String loginForgotPassword = 'Forgot password?';
  static const String loginButton = 'L O G I N';
  static const String loginSignUp = "Don't have an account yet? ";
  static const String loginSignUpLink = 'Sign up';

  // Sign up page strings
  static const String signUpConfirmPasswordHint = 'Confirm Password';
  static const String signUpDividerText = 'or';
  static const String signUpButtonText = 'S I G N   U P';
  static const String signUpAlreadyHaveAccount = 'Already have an account? ';
  static const String signUpLogIn = 'Log in';
  static const String passwordReq =
      'The password must meet the following criteria: It should contain at least 8 characters. It must include at least one lowercase letter, one uppercase letter, one numeric digit, and one special character';
  static const String passwordCheckerError =
      'Please make sure your password meets these requirements to ensure the security of your account.';
  static const String invalidEmailError = 'Please enter a valid email address.';

  // Forgot Password Page strings
  static const String toastPleaseEnterEmail = 'Please enter your email.';
  static const String toastPasswordResetEmailSent =
      'Password reset email sent.';
  static const String toastFailedToSendPasswordResetEmail =
      'Failed to send password reset email.';
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String forgotPasswordEnterEmail =
      'Please enter the email associated with your account to reset your password.';
  static const String forgotPasswordEmailLabel = 'Email';
  static const String forgotPasswordCancelButton = 'Cancel';
  static const String forgotPasswordSendRequestButton = 'Send Request';

  // Home Page Bottom navigation bar strings
  static const String bottomNavHome = 'Home';
  static const String bottomNavExplore = 'Explore';
  static const String bottomNavUpload = 'Upload';
  static const String bottomNavOrganizations = 'Organizations';
  static const String bottomNavProfile = 'Profile';

  // Explore page strings
  static const String explorePageTitle = 'Categories Filter';
  static const String failedToUpdateIssueTypesError =
      'Failed to update user issue types: ';
  static const String failedToFetchUserDocumentError =
      'Failed to fetch user document: ';
  static const String errorPrefix = 'Error: ';

  // Upload Post Page
  // AppBar strings
  static const String uploadPostTitle = 'Upload Post';
  // SwitchListTile strings
  static const String postAnonymously = 'Post Anonymously';
  // TextFormField strings
  static const String postTextFieldHint = 'Write your post here...';
  // ModernButton strings
  static const String uploadButtonText = 'Upload';
  static const String addPhotoButtonText = 'Add Photo';
  // Helper showToast string
  static const String postIsEmpty = 'Post is empty';
  static const String userAnonymously = 'Anonymous User';

  // User Profile page
  // AppBar strings
  static const String userProfileTitle = 'User Profile';
  // User profile strings
  static const String detailsText = 'Details';
  static const String nameText = 'Name';
  static const String bioText = 'Bio';
  static const String postsText = 'Posts';
  static const String myDetailsText = 'My Details';
  static const String myPostsText = 'My Posts';
  static const String usernameDialogTitle = 'Username';


  // Issues/Categories
  static const List<String> allIssues = [
    'Love',
    'Divorce',
    'PTSD',
    'Abuse',
    'Anxiety',
    'Depression',
    'Stress',
    'Grief',
    'Addiction',
    'Eating Disorders',
    'Self-esteem',
    'Loneliness',
    'Bullying',
    'Trauma',
    'Anger Management',
    'Parenting',
    'Relationships',
    'Career',
    'Financial Issues',
    'Body Image',
    'Self-Harm',
    'Suicidal Thoughts',
    'Phobias',
    'Sleep Disorders',
    'Other'
  ];

  // PostWidget
  static const String postWidgetHint = 'What is on your mind?...';
  //Report Section Options
  static const String postReportType = 'post';
  static const String userReportType = 'user';
  static const String commentReportType = 'comment';

  static const List<String> reportPostOptions = [
    'Misleading or False Information',
    'Inappropriate or Offensive Content',
    'Intellectual Property Infringement',
    'Violation of Community Standards',
    'Spam or Advertisement',
  ];

  static const List<String> reportCommentOptions = [
    'Offensive or Abusive Language',
    'Hate Speech',
    'Spam or Irrelevant Content',
    'Inappropriate or NSFW Content',
    'Violation of Community Guidelines',
  ];

  static const List<String> reportUserOptions = [
    'Harassment or Bullying',
    'Impersonation',
    'Spam or Advertising',
    'Inappropriate Content',
    'Violation of Terms of Service',
    'Privacy Invasion',
  ];
}
