const fs = require('fs');
const glob = require('glob');

const entityFiles = glob.sync('src/**/*.entity.ts');

entityFiles.forEach(filePath => {
  let content = fs.readFileSync(filePath, 'utf8');
  const originalContent = content;

  // Remove @Index() decorator from fields (single line above field declaration)
  // Pattern: @Column(...)\n  @Index()\n  field_name:
  content = content.replace(/(@Column\([^)]*\)[^\n]*\n)  @Index\(\)\n  ([a-z_]+):/g, '$1  $2:');
  
  // Pattern: @Column(...)\n  @Index()\n  @AnotherDecorator()\n  field_name:
  content = content.replace(/(@Column\([^)]*\)[^\n]*\n)  @Index\(\)\n(  @[^\n]+\n)  ([a-z_]+):/g, '$1$2  $3:');

  if (content !== originalContent) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`✓ Fixed: ${filePath}`);
  }
});

console.log('Done!');
