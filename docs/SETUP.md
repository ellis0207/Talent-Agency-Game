# Setup: from zero to playing the game

This guide assumes you have never used Godot. It takes about 15 minutes. Steps are given for **Windows** and **Mac**; follow the one for your computer.

You need three things:

1. **GitHub Desktop**, to download the project and keep it up to date.
2. **Godot 4.7** (the game engine), to open and run it.
3. This project.

You do **not** need Unreal or Blender for this. (Blender may come in handy for art later.)

---

## 1. Install GitHub Desktop and download the project

GitHub Desktop is a free app that copies the project to your computer and pulls in new changes with one click.

1. Go to **https://desktop.github.com** and download GitHub Desktop for your system.
   - **Windows:** run the downloaded installer. It installs and opens by itself.
   - **Mac:** open the downloaded `.zip`, then drag **GitHub Desktop** into your **Applications** folder and open it.
2. Sign in with your GitHub account (`ellis0207`).
3. Choose **File → Clone repository…**, pick **ellis0207/talent-agency-game** from the list, and choose where to save it (for example `Documents\GitHub` on Windows or `Documents/GitHub` on a Mac). Click **Clone**.

### Trying a change before it is merged

New work arrives as a *pull request* on its own branch. To try one before it is merged:

1. In GitHub Desktop, click **Current Branch** at the top.
2. Pick the branch named in the pull request (for Phase 0 it is `claude/project-thread-pzx06b`). If you don't see it, click **Fetch origin** first.
3. The files on your computer now match that branch. Open the project in Godot as below.

Switch back to **main** the same way when you are done. After a pull request is merged, select **main** and click **Fetch origin**, then **Pull origin**.

---

## 2. Install Godot 4.7

Godot does not need an installer: you download it, unzip it and run it. Get the **standard** version, **not** the ".NET" one (we use Godot's own language, GDScript).

1. Go to **https://godotengine.org/download**.
2. Download **Godot Engine 4.7** (any 4.7.x version) for your system. The page usually picks your system automatically.

### Windows

3. Open your **Downloads** folder, right-click the zip (named like `Godot_v4.7.2-stable_win64.exe.zip`) and choose **Extract All…**. Extract it somewhere you'll remember, for example `C:\Godot`.
4. Open that folder and double-click **`Godot_v4.7.2-stable_win64.exe`**. (Ignore the file ending in `_console.exe`; it's the same program with an extra text window for troubleshooting.)
5. If Windows shows **"Windows protected your PC"**, click **More info → Run anyway**.
6. Optional: right-click the `.exe` → **Show more options → Send to → Desktop (create shortcut)** so you can find it again.

### Mac

3. Open your **Downloads** folder and double-click the zip (named like `Godot_v4.7.2-stable_macos.universal.zip`) to unzip it.
4. Drag **Godot.app** into your **Applications** folder.
5. Open **Godot** from Applications. If macOS says it can't check the app, go to **System Settings → Privacy & Security**, scroll down and click **Open Anyway**.

> **Tip:** Godot is also on Steam, but Steam updates it automatically, which can jump to a newer version than the project uses. The download from the website is the safer choice for now.

---

## 3. Open the project in Godot

When Godot starts, you see the **Project Manager**: a list of your projects (empty the first time).

1. Click **Import** (top left).
2. Browse to the folder you cloned in step 1 (for example `Documents/GitHub/talent-agency-game`) and select the file **`project.godot`**.
3. Click **Import** (it may say **Import & Edit**).
4. The editor opens. The first time, Godot spends a few seconds importing files; let it finish.

If Godot offers a tour of the editor, it's worth a look.

### A 60-second tour of the editor

- **Top center:** tabs for **2D**, **3D**, **Script** and **AssetLib**. We mostly use **2D** and **Script**.
- **Top right:** the **▶ Run Project** button (and **Run Current Scene** next to it).
- **Left, bottom:** the **FileSystem** dock, showing the project's folders (`scenes`, `scripts`, `data`, `tests`, ...). Double-click a file to open it.
- **Left, top:** the **Scene** dock, showing the pieces of the scene that is open.
- **Right:** the **Inspector**, showing the settings of whatever is selected.
- **Bottom:** the **Output** panel, where messages and errors appear.

---

## 4. Play the Phase 0 build

Press **F5** (Mac: **Cmd + B**), or click **▶** at the top right. A game window opens.

Things to try:

1. You see your agency's name, **Year 1 · Week 1**, your cash, a cartoon building where you rent the ground floor, and an **Inbox** with your opening message.
2. Click **Advance week** (or press **Space**). The week goes up, rent is paid, the phone rings, and a new headline lands in the inbox with any money it earned or cost.
3. Keep going. The calendar on the office wall follows the week. When cash gets low, a warning appears at the top.
4. Run out of money and the agency is **closed for good**. Click **Open a new agency** to start again with a new name and a new random world.
5. The **world seed** in the bottom-left corner identifies each run. If something odd happens, note the seed so the run can be replayed exactly.

Close the game window (or press **F8**) to return to the editor.

## 5. Run the tests

The project has automatic tests that check the game rules.

1. In the **FileSystem** dock, open the `tests` folder and double-click **`test_runner.tscn`**.
2. Press **F6** (Mac: **Cmd + R**), or click **Run Current Scene** at the top right.
3. A window opens saying **ALL TESTS PASSED** in green, with a list of every test. If any fail, they're listed in red. The same list appears in the **Output** panel.

The same tests also run automatically on GitHub for every pull request (the green check mark or red cross on the pull request page).

---

## Troubleshooting

- **"This project was made with a newer version of Godot"** or a warning about converting the project: you have an older Godot. Install 4.7.x as above. Don't let an older version convert the project.
- **The game window is blank or Godot crashes on start (older computers):** the project already uses Godot's most compatible graphics mode. Make sure your graphics drivers are up to date.
- **Red errors in the Output panel:** copy them into the project chat and we'll fix them.
- **The branch isn't listed in GitHub Desktop:** click **Fetch origin**, then look again.

## Optional: run the tests from a terminal

If you're comfortable with a terminal, from the project folder:

- **Windows (PowerShell):** `& "C:\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path . -s res://tests/run_tests.gd`
- **Mac:** `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . -s res://tests/run_tests.gd`

It prints each test and ends with a count of passed and failed tests.
