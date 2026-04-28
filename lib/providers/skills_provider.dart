import 'dart:io';

({String promptwrightSkill, String playwrightCliSkill}) loadSkills() {
  try {
    final promptwrightSkill = File(
      'lib/skills/promptwright.md',
    ).readAsStringSync();
    final playwrightCliSkill = File(
      'lib/skills/playwright-cli.md',
    ).readAsStringSync();
    return (
      promptwrightSkill: promptwrightSkill,
      playwrightCliSkill: playwrightCliSkill,
    );
  } catch (e) {
    throw Exception('Failed to load critical skills: $e');
  }
}
