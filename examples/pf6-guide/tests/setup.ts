import { execSync } from 'child_process';
import * as path from 'path';

export default async function globalSetup() {
  const guideDir = path.resolve(__dirname, '..');
  console.log('\nCompiling Elm app...');
  execSync('elm make src/Main.elm --output=main.js', {
    cwd: guideDir,
    stdio: 'inherit',
  });
  console.log('Elm compilation complete.\n');
}
