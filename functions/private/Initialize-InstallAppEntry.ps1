function Initialize-InstallAppEntry {
    <#
        .SYNOPSIS
            Creates the app entry to be placed on the install tab for a given app
            Used to as part of the Install Tab UI generation
        .PARAMETER TargetElement
            The Element into which the Apps should be placed
        .PARAMETER appKey
            The Key of the app inside the $sync.configs.applicationsHashtable
    #>
        param(
            [Windows.Controls.WrapPanel]$TargetElement,
            $appKey
        )

        $app = $sync.configs.applicationsHashtable[$appKey]
        $handlers = Get-WinUtilAppEntryHandlers

        # Create the outer Border for the application type
        $border = New-Object Windows.Controls.Border
        $border.Style = $sync.Form.Resources.AppEntryBorderStyle
        $border.Tag = $appKey
        $border.ToolTip = Get-WinUtilEntryToolTip -Description $app.description -Key $appKey
        $border.Add_MouseLeftButtonUp($handlers.BorderClick)
        $border.Add_MouseEnter($handlers.MouseEnter)
        $border.Add_MouseLeave($handlers.MouseLeave)
        $border.Add_MouseRightButtonUp($handlers.RightClick)

        $checkBox = New-Object Windows.Controls.CheckBox
        # Sanitize the name for WPF (dots and other invalid name characters become underscores)
        $checkBox.Name = $appKey -replace '[^a-zA-Z0-9_]', '_'
        # Store the original appKey in Tag
        $checkBox.Tag = $appKey
        $checkbox.Style = $sync.Form.Resources.AppEntryCheckboxStyle
        $checkbox.Add_Checked($handlers.Checked)
        $checkbox.Add_Unchecked($handlers.Unchecked)

        $contentPanel = New-Object Windows.Controls.StackPanel
        $contentPanel.Orientation = "Horizontal"
        $contentPanel.VerticalAlignment = [Windows.VerticalAlignment]::Center

        $icon = New-Object Windows.Controls.Grid
        $icon.SetResourceReference([Windows.FrameworkElement]::WidthProperty, "AppEntryIconSize")
        $icon.SetResourceReference([Windows.FrameworkElement]::HeightProperty, "AppEntryIconSize")
        $icon.Margin = New-Object Windows.Thickness(0, 0, 8, 0)
        $fallback = New-Object Windows.Controls.TextBlock
        $fallback.Text = $app.content.TrimStart(".").Substring(0, 1).ToUpper()
        $fallback.FontWeight = "Bold"; $fallback.HorizontalAlignment = "Center"; $fallback.VerticalAlignment = "Center"
        $fallback.SetResourceReference([Windows.Controls.TextBlock]::FontSizeProperty, "AppEntryFontSize")
        $fallback.SetResourceReference([Windows.Controls.TextBlock]::ForegroundProperty, "ToggleButtonOnColor")
        [void]$icon.Children.Add($fallback)
        if ($app.link) {
            $fallback.Visibility = "Collapsed"
            $logo = New-Object Windows.Controls.Image
            $logo.Stretch = [Windows.Media.Stretch]::Uniform
            # Carries the app link so the shared ImageFailed handler can
            # retry once through the alternate favicon provider.
            $logo.Tag = @{ Link = $app.link; Retried = $false }
            $logo.Add_ImageFailed($handlers.ImageFailed)
            try {
                # BitmapImage with default (on-demand) caching downloads
                # asynchronously: a blocked or failed favicon surfaces through
                # ImageFailed instead of throwing here and aborting the whole
                # render batch, which would leave the Install tab empty.
                $favicon = New-Object Windows.Media.Imaging.BitmapImage
                $favicon.BeginInit()
                $favicon.UriSource = "https://www.google.com/s2/favicons?sz=64&domain_url=$([uri]::EscapeDataString($app.link))"
                $favicon.EndInit()
                $logo.Source = $favicon
            } catch {
                # Log each distinct failure once: silent fallbacks make
                # icon outages undebuggable (every entry just shows a letter).
                if ($null -eq $sync.FaviconFailureLog) { $sync.FaviconFailureLog = @{} }
                $inner = ""
                if ($_.Exception.InnerException) { $inner = " <- " + $_.Exception.InnerException.GetType().Name + ": " + $_.Exception.InnerException.Message }
                $catchReason = "entry-setup: " + $_.Exception.GetType().Name + ": " + $_.Exception.Message + $inner
                if ($catchReason.Length -gt 300) { $catchReason = $catchReason.Substring(0, 300) }
                if (-not $sync.FaviconFailureLog.ContainsKey($catchReason)) {
                    $sync.FaviconFailureLog[$catchReason] = $true
                    Write-WinUtilLog -Level "DEBUG" -Component "UI" -Message "Favicon setup failed ($catchReason); showing letter fallback."
                }
                $logo.Visibility = "Collapsed"
                $fallback.Visibility = "Visible"
            }

            [void]$icon.Children.Add($logo)
        }
        [void]$contentPanel.Children.Add($icon)

        # Create the TextBlock for the application name
        $appName = New-Object Windows.Controls.TextBlock
        $appName.Style = $sync.Form.Resources.AppEntryNameStyle
        $appName.Text = $app.content

        # Add FOSS label after the name if FOSS
        [void]$contentPanel.Children.Add($appName)
        $checkBox.Content = $contentPanel

        # Add accessibility properties to make the elements screen reader friendly
        $checkBox.SetValue([Windows.Automation.AutomationProperties]::NameProperty, $app.content)
        $border.SetValue([Windows.Automation.AutomationProperties]::NameProperty, $app.content)

        # Keep the same layout for every entry so the checkbox handlers can reach the border
        $entryLayout = New-Object Windows.Controls.Grid
        [void]$entryLayout.Children.Add($checkBox)

        # Mark FOSS apps with a corner badge, bled into the border padding so it sits on the edge
        if ($app.foss -eq $true) {
            $fossBadge = New-WinUtilFossBadge
            $fossBadge.HorizontalAlignment = "Right"
            $fossBadge.VerticalAlignment = "Top"
            $fossBadge.Margin = New-Object Windows.Thickness(0, -4, -6, 0)

            [void]$entryLayout.Children.Add($fossBadge)
        }

        $border.Child = $entryLayout
        if ($sync.selectedApps -contains $appKey) {
            $checkBox.IsChecked = $true
        }
        # Add the border to the corresponding Category
        $TargetElement.Children.Add($border) | Out-Null
        return $checkbox
    }
