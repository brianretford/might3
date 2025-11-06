# Might3 Usage Examples

This guide shows you how to use Might3 effectively.

## Basic Usage

### Adding Your First Task

1. Launch the app
2. Type in the text field at the top
3. Press Enter or click the + button
4. Your task appears in the list!

### Completing a Task

1. Click the circle icon next to the task
2. It turns green with a checkmark
3. The task text gets a strikethrough
4. Completed tasks move to the bottom

### Deleting a Task

1. Click the trash icon on the right
2. Task is immediately removed
3. No confirmation needed (be careful!)

### Managing Priority

Tasks are automatically prioritized by:
1. Incomplete tasks appear first
2. Then sorted by priority number (higher = more important)
3. Then by creation date (older first)

## The "Top 3" Philosophy

### Why Only 3?

Research shows that focusing on 3 tasks per day:
- Reduces overwhelm
- Increases completion rate
- Improves focus
- Creates momentum

### Best Practices

**Morning Routine**
1. Open Might3
2. Review yesterday's tasks
3. Add/update your top 3 for today
4. Keep the window visible all day

**Daily Review**
1. End of day: Check what's complete
2. Remove or update tasks
3. Preview tomorrow's priorities
4. Start fresh each day

**Weekly Planning**
1. Sunday evening: Set up top 3 for Monday
2. Review the week's accomplishments
3. Adjust priorities for the week ahead

## macOS Desktop Widget Tips

### Positioning

**Top-Right Corner**: Great for monitoring while working
```
┌─────────────────────────────┐
│                    [Might3] │
│                    - Task 1 │
│                    - Task 2 │
│  [Your Work Here]  - Task 3 │
│                             │
```

**Left Side**: Good for ultra-wide monitors
```
┌──────────┬────────────────────┐
│ [Might3] │                    │
│ - Task 1 │  [Your Work Here]  │
│ - Task 2 │                    │
│ - Task 3 │                    │
└──────────┴────────────────────┘
```

**Bottom Center**: Taskbar replacement
```
┌─────────────────────────────┐
│                             │
│     [Your Work Here]        │
│                             │
├─────────────────────────────┤
│  [Might3] T1 | T2 | T3      │
└─────────────────────────────┘
```

### Keyboard Shortcuts

The widget is always visible, but:
- Click to focus and add tasks
- Tab to switch between tasks
- Enter to add new task
- Escape to hide keyboard

### Transparency Tips

Adjust visibility by:
- Moving to different backgrounds
- Using with dark/light wallpapers
- Positioning over solid colors
- Avoiding busy background areas

## iOS Widget Usage

### Adding the Widget

1. Long-press on home screen
2. Tap the + button (top-left)
3. Search for "Might3"
4. Choose widget size:
   - **Small**: Perfect for glanceable view
   - **Medium**: Shows more detail
5. Tap "Add Widget"
6. Drag to desired position

### Widget Sizes

**Small Widget (2x2)**
- Shows top 3 tasks
- Minimal design
- Best for: Quick glance
- Location: Home screen corner

**Medium Widget (4x2)**
- Shows top 3 tasks with more detail
- Includes app branding
- Best for: Primary widget
- Location: Top of home screen

### Widget Updates

- Automatic: Every 15 minutes
- Manual: Open the app to force refresh
- Background: System decides best time
- Note: May not update if battery is low

### Widget Best Practices

**Placement Ideas**
- Top of home screen: First thing you see
- Widget page: Swipe right from home
- Lock screen (iOS 16+): Always visible

**Smart Stacks**
- Add Might3 to a widget stack
- Auto-rotation shows tasks at key times
- Combine with calendar, reminders

## Workflow Examples

### Developer Workflow

**Morning Setup (9 AM)**
```
1. Fix bug #123
2. Review pull requests
3. Write unit tests for feature X
```

**Check Progress (Lunch)**
- ✅ Fix bug #123
- ⭕ Review pull requests (in progress)
- ⭕ Write unit tests

**End of Day (5 PM)**
- ✅ Fix bug #123
- ✅ Review pull requests
- ⭕ Write unit tests → Move to tomorrow

### Student Workflow

**Study Session**
```
1. Read Chapter 5 (Biology)
2. Math homework problems 1-10
3. Prepare presentation slides
```

**Break Time Check**
- ✅ Read Chapter 5
- ⭕ Math homework (7/10 done)
- ⭕ Presentation slides

### Personal Tasks

**Weekend Todo**
```
1. Grocery shopping
2. Call Mom
3. Gym workout
```

**Throughout the day**
- Check off as completed
- Widget reminds you constantly
- Satisfaction of completing all 3!

## Supabase Sync

### How Sync Works

1. **Auto-sync**: Every task change syncs to cloud
2. **On launch**: Latest data pulled from server
3. **Offline**: Works perfectly, syncs when online
4. **Conflict**: Last write wins (for now)

### Multi-Device Usage

**Setup**
1. Install on macOS and iOS
2. Use same Supabase credentials
3. Both devices sync automatically

**Workflow**
1. Add task on Mac → Syncs to cloud
2. View on iPhone widget → Updates in 15 min
3. Complete on iPhone → Syncs to cloud
4. Mac updates on next change/launch

### Offline Usage

**Going Offline**
1. All tasks available offline
2. Add/edit/delete works normally
3. Changes queued for sync
4. Auto-syncs when online

**Best Practices**
- Create tasks before flight
- Update during offline time
- Sync will catch up when online
- No data loss

## Advanced Usage

### Task Naming Tips

**Good Task Names**
- ✅ "Review PR #123 for auth feature"
- ✅ "Write 500 words on intro section"
- ✅ "Call dentist to schedule appointment"

**Poor Task Names**
- ❌ "Work stuff"
- ❌ "Things to do"
- ❌ "Misc"

### Using with Other Tools

**Might3 + Calendar**
- Might3: What to do today
- Calendar: When to do it

**Might3 + Project Manager**
- Project Manager: All tasks
- Might3: Today's top 3 from that list

**Might3 + Notes**
- Notes: Detailed information
- Might3: Action items from notes

### Habit Formation

**Week 1**: Just add 3 tasks daily
**Week 2**: Complete at least 2/3 daily
**Week 3**: Complete all 3, celebrate!
**Week 4**: It's now a habit!

## Troubleshooting Usage

### "I have more than 3 tasks!"

That's normal! The key is:
- Might3 shows your TOP 3 priorities
- Keep a full list elsewhere (Notion, Things, etc.)
- Move top 3 to Might3 each day
- Focus on these first

### "Tasks aren't syncing"

Check:
1. Internet connection active?
2. Supabase credentials correct?
3. Open app to force sync
4. Check Supabase dashboard for data

### "Widget not updating"

Try:
1. Open the main app (forces update)
2. Remove and re-add widget
3. Restart device
4. Check iOS Background App Refresh

### "Window is too transparent"

macOS app:
1. Opacity is set to 95%
2. Move to different background
3. Use with solid color wallpapers
4. Future update will add opacity control

## Tips & Tricks

### Power User Tips

1. **Morning Ritual**: Review + Update tasks first thing
2. **Pomodoro**: One task per pomodoro session
3. **Time Block**: Schedule time for each task
4. **Weekly Review**: Check completion rate

### Productivity Hacks

1. **MIT (Most Important Task)**: Make #1 your biggest priority
2. **Quick Wins**: Include one easy task for momentum
3. **Time Estimates**: Mentally note how long each takes
4. **Batch Similar**: Group similar tasks together

### Focus Techniques

1. **Single-Task**: Only work on task #1 until done
2. **Visible Reminder**: Keep widget always visible
3. **No Multitask**: Finish before moving to next
4. **Celebrate Wins**: Acknowledge each completion

## Getting More Value

### Track Your Progress

Keep a journal:
- Daily: How many tasks completed?
- Weekly: What patterns emerge?
- Monthly: How has focus improved?

### Adjust Your System

Experiment with:
- Task sizing (large vs. small tasks)
- Time requirements (30 min vs. 2 hours)
- Task types (mix of easy and hard)
- Update frequency (morning only vs. throughout day)

### Share Your Experience

Help others:
- Screenshot your workflow
- Share on social media
- Write blog posts
- Contribute improvements

## Support

Need help? Check:
- [README.md](README.md) - General info
- [SETUP.md](SETUP.md) - Installation
- [GitHub Issues](https://github.com/brianretford/might3/issues) - Bug reports
- [Discussions](https://github.com/brianretford/might3/discussions) - Questions

---

Remember: The goal isn't to do everything - it's to do the right things. Focus on your top 3!
