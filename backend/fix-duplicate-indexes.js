const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Find all entity files
const entityFiles = glob.sync('src/**/*.entity.ts');

console.log(`Found ${entityFiles.length} entity files`);

entityFiles.forEach(filePath => {
  let content = fs.readFileSync(filePath, 'utf8');
  const originalContent = content;

  // Extract class-level @Index decorators
  const classLevelIndexes = [];
  const classIndexPattern = /@Index\(\['([^']+)'\](?:,\s*\{[^}]+\})?\)/g;
  let match;

  // Find all class-level indexes before 'export class'
  const classStart = content.indexOf('export class');
  if (classStart === -1) return;

  const beforeClass = content.substring(0, classStart);
  while ((match = classIndexPattern.exec(beforeClass)) !== null) {
    classLevelIndexes.push(match[1]);
  }

  if (classLevelIndexes.length === 0) return;

  console.log(`\nProcessing: ${filePath}`);
  console.log(`Class-level indexes: ${classLevelIndexes.join(', ')}`);

  // Remove duplicate @Index() decorators from fields
  classLevelIndexes.forEach(fieldName => {
    // Pattern: @Column...\n  @Index()\n  field_name:
    const pattern1 = new RegExp(`(@Column\\([^)]*\\)[^\\n]*\\n)  @Index\\(\\)\\n  ${fieldName}:`, 'g');
    content = content.replace(pattern1, `$1  ${fieldName}:`);

    // Pattern: @Column...\n  @Index()\n  @OtherDecorator()\n  field_name:
    const pattern2 = new RegExp(`(@Column\\([^)]*\\)[^\\n]*\\n)  @Index\\(\\)\\n(  @[^\\n]+\\n)  ${fieldName}:`, 'g');
    content = content.replace(pattern2, `$1$2  ${fieldName}:`);
  });

  if (content !== originalContent) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`✓ Fixed duplicate indexes in ${filePath}`);
  }
});

console.log('\n✓ Done!');
