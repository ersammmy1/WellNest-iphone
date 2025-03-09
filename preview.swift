//
import Foundation

// This is a simple HTML representation of what your WellNest app UI might look like
// We'll generate HTML to visualize the basic components

print("""
<!DOCTYPE html>
<html>
<head>
    <title>WellNest App Preview</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 390px;
            margin: 20px auto;
            background: white;
            border-radius: 30px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            height: 800px;
            position: relative;
        }
        .header {
            padding: 16px;
            background: #f8f8f8;
            border-bottom: 1px solid #eaeaea;
            text-align: center;
            font-weight: bold;
            position: relative;
        }
        .add-button {
            position: absolute;
            right: 16px;
            top: 16px;
        }
        .contact-list {
            overflow-y: auto;
            height: calc(100% - 120px);
        }
        .contact-row {
            display: flex;
            padding: 12px 16px;
            border-bottom: 1px solid #eaeaea;
            align-items: center;
        }
        .contact-info {
            flex: 1;
        }
        .contact-name {
            font-weight: bold;
            margin-bottom: 4px;
        }
        .contact-time {
            font-size: 12px;
            color: #888;
        }
        .mood-emoji {
            font-size: 30px;
            background: rgba(0,0,0,0.05);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        .mood-emoji::after {
            content: '';
            position: absolute;
            top: -10px;
            left: -10px;
            right: -10px;
            bottom: -10px;
            background: radial-gradient(circle at center, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0) 70%);
            opacity: 0.4;
        }
        .happy { 
            background: rgba(26,204,102,0.15); 
            border: 1px solid rgba(26,204,102,0.3);
        }
        .sad { 
            background: rgba(255,128,0,0.15); 
            border: 1px solid rgba(255,128,0,0.3);
        }
        .neutral { 
            background: rgba(51,153,255,0.15); 
            border: 1px solid rgba(51,153,255,0.3);
        }
        .stressed { 
            background: rgba(230,76,76,0.15); 
            border: 1px solid rgba(230,76,76,0.3);
        }
        .anxious {
            background: rgba(153,102,204,0.15);
            border: 1px solid rgba(153,102,204,0.3);
        }
        .tab-bar {
            display: flex;
            position: absolute;
            bottom: 0;
            width: 100%;
            border-top: 1px solid #eaeaea;
            background: white;
        }
        .tab {
            flex: 1;
            padding: 10px 0;
            text-align: center;
            color: #888;
        }
        .tab.active {
            color: #007AFF;
        }
        .widget-container {
            margin-top: 30px;
            max-width: 390px;
            margin: 30px auto;
        }
        .widget {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 16px;
        }
        .widget-small {
            height: 150px;
        }
        .widget-medium {
            height: 170px;
        }
        .widget-large {
            height: 300px;
        }
        .widget-title {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .widget-contacts-small {
            height: calc(100% - 30px);
            overflow: hidden;
        }
        .widget-contact-row {
            display: flex;
            justify-content: space-between;
            margin: 5px 0;
        }
        .widget-mood-grid {
            display: flex;
            justify-content: space-around;
            margin-top: 10px;
        }
        .widget-mood-item {
            text-align: center;
        }
        h2 {
            text-align: center;
            margin-top: 30px;
            color: #333;
        }
    </style>
</head>
<body>
    <h2>WellNest App Preview</h2>
    <div class="container" style="background: #f4f8ff;">
        <!-- App Header -->
        <div class="header" style="display: flex; align-items: center; justify-content: space-between; background: white; padding: 20px 16px; border-bottom: none; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
            <div style="display: flex; align-items: center;">
                <div style="font-size: 26px; color: #3580cc; margin-right: 8px;">♥️</div>
                <div style="font-weight: 700; color: #2a3c4d; font-size: 24px;">WellNest</div>
            </div>
            <div class="add-button" style="background: #3580cc; color: white; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 50%; box-shadow: 0 2px 8px rgba(53,128,204,0.3); font-size: 20px;">+</div>
        </div>
        
        <!-- App description -->
        <div style="padding: 12px 16px; text-align: center; color: #6c7a89; font-size: 15px; background: white; border-bottom: 1px solid #eef2f7; margin-bottom: 12px;">
            Stay connected with those you care about most
        </div>
        
        <div class="contact-list" style="padding: 0 16px 80px 16px;">
            <!-- Contact Cards -->
            <div class="contact-row" style="background: white; border-radius: 12px; margin-bottom: 12px; padding: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border: none;">
                <div class="contact-info">
                    <div class="contact-name" style="font-weight: 600; color: #2a3c4d; font-size: 18px;">Emma</div>
                    <div class="contact-time" style="display: flex; align-items: center; color: #6c7a89; font-size: 13px; margin-top: 4px;">
                        <span style="margin-right: 4px; font-size: 12px;">⏱</span>
                        Last updated: 2m ago
                    </div>
                </div>
                <div class="mood-emoji happy">😊</div>
            </div>
            
            <div class="contact-row" style="background: white; border-radius: 12px; margin-bottom: 12px; padding: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border: none;">
                <div class="contact-info">
                    <div class="contact-name" style="font-weight: 600; color: #2a3c4d; font-size: 18px;">James</div>
                    <div class="contact-time" style="display: flex; align-items: center; color: #6c7a89; font-size: 13px; margin-top: 4px;">
                        <span style="margin-right: 4px; font-size: 12px;">⏱</span>
                        Last updated: 1h ago
                    </div>
                </div>
                <div class="mood-emoji sad">😔</div>
            </div>
            
            <div class="contact-row" style="background: white; border-radius: 12px; margin-bottom: 12px; padding: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border: none;">
                <div class="contact-info">
                    <div class="contact-name" style="font-weight: 600; color: #2a3c4d; font-size: 18px;">Sophia</div>
                    <div class="contact-time" style="display: flex; align-items: center; color: #6c7a89; font-size: 13px; margin-top: 4px;">
                        <span style="margin-right: 4px; font-size: 12px;">⏱</span>
                        Last updated: 2h ago
                    </div>
                </div>
                <div class="mood-emoji neutral">😐</div>
            </div>
            
            <div class="contact-row" style="background: white; border-radius: 12px; margin-bottom: 12px; padding: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border: none;">
                <div class="contact-info">
                    <div class="contact-name" style="font-weight: 600; color: #2a3c4d; font-size: 18px;">Noah</div>
                    <div class="contact-time" style="display: flex; align-items: center; color: #6c7a89; font-size: 13px; margin-top: 4px;">
                        <span style="margin-right: 4px; font-size: 12px;">⏱</span>
                        Last updated: 3h ago
                    </div>
                </div>
                <div class="mood-emoji stressed">😫</div>
            </div>
        </div>
        
        <!-- Tab Bar -->
        <div class="tab-bar" style="background: white; border-top: 1px solid #eef2f7; box-shadow: 0 -2px 10px rgba(0,0,0,0.05);">
            <div class="tab active" style="color: #3580cc; font-weight: 600;">🏠</div>
            <div class="tab" style="color: #6c7a89;">📚</div>
            <div class="tab" style="color: #6c7a89;">⚙️</div>
        </div>
    </div>

    <h2>Widget Previews</h2>
    
    <div class="widget-container">
        <div class="widget widget-small" style="background: linear-gradient(135deg, #ffffff, #f4f8ff);">
            <div class="widget-title" style="margin-bottom: 10px;">
                <div style="display: flex; align-items: center;">
                    <span style="font-size: 16px; color: #3580cc; margin-right: 5px;">♥️</span>
                    <span style="font-weight: 600; color: #2a3c4d;">WellNest</span>
                </div>
                <div style="color: #e66c6c;">❤️</div>
            </div>
            
            <!-- Divider -->
            <div style="height: 2px; background: linear-gradient(to right, #3580cc, #e66c6c); margin-bottom: 12px;"></div>
            
            <div class="widget-contacts-small">
                <div class="widget-contact-row" style="margin: 8px 0; display: flex; justify-content: space-between; align-items: center;">
                    <div style="font-weight: 500; color: #2a3c4d;">Emma</div>
                    <div class="mood-emoji happy" style="width: 36px; height: 36px; font-size: 18px;">😊</div>
                </div>
                <div class="widget-contact-row" style="margin: 8px 0; display: flex; justify-content: space-between; align-items: center;">
                    <div style="font-weight: 500; color: #2a3c4d;">James</div>
                    <div class="mood-emoji sad" style="width: 36px; height: 36px; font-size: 18px;">😔</div>
                </div>
                <div class="widget-contact-row" style="margin: 8px 0; display: flex; justify-content: space-between; align-items: center;">
                    <div style="font-weight: 500; color: #2a3c4d;">Sophia</div>
                    <div class="mood-emoji neutral" style="width: 36px; height: 36px; font-size: 18px;">😐</div>
                </div>
            </div>
        </div>
    </div>

    <div class="widget-container">
        <div class="widget widget-medium" style="background: #f4f8ff; position: relative; overflow: hidden;">
            <!-- Decorative circles -->
            <div style="position: absolute; width: 100px; height: 100px; background: rgba(51,153,255,0.05); border-radius: 50%; top: -50px; left: -50px;"></div>
            <div style="position: absolute; width: 80px; height: 80px; background: rgba(230,76,76,0.05); border-radius: 50%; bottom: -20px; right: -20px;"></div>
            
            <div class="widget-title" style="margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center;">
                <div style="display: flex; align-items: center;">
                    <span style="font-size: 18px; color: #3580cc; margin-right: 5px;">♥️</span>
                    <span style="font-weight: 600; color: #2a3c4d; font-size: 16px;">WellNest</span>
                </div>
                <div style="background: #f0f2f6; padding: 4px 10px; border-radius: 15px; color: #6c7a89; font-size: 13px; font-weight: 500; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">Wellness Check</div>
            </div>
            
            <div class="widget-mood-grid" style="display: flex; justify-content: space-around; align-items: center;">
                <div class="widget-mood-item" style="text-align: center;">
                    <div class="mood-emoji happy" style="width: 56px; height: 56px; font-size: 28px; margin: 0 auto; position: relative; box-shadow: 0 3px 8px rgba(26,204,102,0.2);">
                        <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: radial-gradient(circle at center, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0) 70%); opacity: 0.6;"></div>
                        😊
                    </div>
                    <div style="margin-top: 8px; font-weight: 500; color: #2a3c4d; font-size: 13px;">Emma</div>
                </div>
                <div class="widget-mood-item" style="text-align: center;">
                    <div class="mood-emoji sad" style="width: 56px; height: 56px; font-size: 28px; margin: 0 auto; position: relative; box-shadow: 0 3px 8px rgba(255,128,0,0.2);">
                        <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: radial-gradient(circle at center, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0) 70%); opacity: 0.6;"></div>
                        😔
                    </div>
                    <div style="margin-top: 8px; font-weight: 500; color: #2a3c4d; font-size: 13px;">James</div>
                </div>
                <div class="widget-mood-item" style="text-align: center;">
                    <div class="mood-emoji neutral" style="width: 56px; height: 56px; font-size: 28px; margin: 0 auto; position: relative; box-shadow: 0 3px 8px rgba(51,153,255,0.2);">
                        <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: radial-gradient(circle at center, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0) 70%); opacity: 0.6;"></div>
                        😐
                    </div>
                    <div style="margin-top: 8px; font-weight: 500; color: #2a3c4d; font-size: 13px;">Sophia</div>
                </div>
                <div class="widget-mood-item" style="text-align: center;">
                    <div class="mood-emoji stressed" style="width: 56px; height: 56px; font-size: 28px; margin: 0 auto; position: relative; box-shadow: 0 3px 8px rgba(230,76,76,0.2);">
                        <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: radial-gradient(circle at center, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0) 70%); opacity: 0.6;"></div>
                        😫
                    </div>
                    <div style="margin-top: 8px; font-weight: 500; color: #2a3c4d; font-size: 13px;">Noah</div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="widget-container">
        <div class="widget widget-large" style="background: #f4f8ff; position: relative; overflow: hidden;">
            <!-- Decorative wave -->
            <div style="position: absolute; width: 200px; height: 80px; background: rgba(51,153,255,0.1); border-radius: 100px; top: -20px; left: -50px; transform: rotate(-15deg);"></div>
            <div style="position: absolute; width: 180px; height: 60px; background: rgba(51,153,255,0.05); border-radius: 100px; top: -40px; right: -50px; transform: rotate(-5deg);"></div>
            
            <div class="widget-title" style="margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center;">
                <div style="display: flex; align-items: center;">
                    <span style="font-size: 22px; color: #3580cc; margin-right: 8px;">♥️</span>
                    <span style="font-weight: 700; color: #2a3c4d; font-size: 20px;">WellNest</span>
                </div>
                <div style="background: white; padding: 6px 12px; border-radius: 20px; color: #6c7a89; font-size: 14px; font-weight: 500; box-shadow: 0 1px 3px rgba(0,0,0,0.05); display: flex; align-items: center;">
                    <span>Your Circle</span>
                    <span style="margin-left: 4px;">👪</span>
                </div>
            </div>
            
            <!-- Divider -->
            <div style="height: 2px; background: linear-gradient(to right, #3580cc, #e66c6c); margin-bottom: 16px;"></div>
            
            <div class="large-widget-contacts" style="display: flex; flex-direction: column; gap: 12px;">
                <div style="background: white; padding: 12px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.03);">
                    <div style="display: flex; align-items: center;">
                        <span style="width: 8px; height: 8px; background: #1acc66; border-radius: 50%; display: inline-block; margin-right: 8px;"></span>
                        <span style="font-weight: 600; color: #2a3c4d; font-size: 16px;">Emma</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div class="mood-emoji happy" style="width: 44px; height: 44px; font-size: 22px;">😊</div>
                        <div style="background: white; padding: 4px 10px; border-radius: 15px; color: #6c7a89; font-size: 13px; font-weight: 500; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">2m ago</div>
                    </div>
                </div>
                
                <div style="background: white; padding: 12px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.03);">
                    <div style="display: flex; align-items: center;">
                        <span style="width: 8px; height: 8px; background: #ff8000; border-radius: 50%; display: inline-block; margin-right: 8px;"></span>
                        <span style="font-weight: 600; color: #2a3c4d; font-size: 16px;">James</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div class="mood-emoji sad" style="width: 44px; height: 44px; font-size: 22px;">😔</div>
                        <div style="background: white; padding: 4px 10px; border-radius: 15px; color: #6c7a89; font-size: 13px; font-weight: 500; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">1h ago</div>
                    </div>
                </div>
                
                <div style="background: white; padding: 12px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.03);">
                    <div style="display: flex; align-items: center;">
                        <span style="width: 8px; height: 8px; background: #3399ff; border-radius: 50%; display: inline-block; margin-right: 8px;"></span>
                        <span style="font-weight: 600; color: #2a3c4d; font-size: 16px;">Sophia</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div class="mood-emoji neutral" style="width: 44px; height: 44px; font-size: 22px;">😐</div>
                        <div style="background: white; padding: 4px 10px; border-radius: 15px; color: #6c7a89; font-size: 13px; font-weight: 500; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">2h ago</div>
                    </div>
                </div>
                
                <div style="background: white; padding: 12px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.03);">
                    <div style="display: flex; align-items: center;">
                        <span style="width: 8px; height: 8px; background: #e64c4c; border-radius: 50%; display: inline-block; margin-right: 8px;"></span>
                        <span style="font-weight: 600; color: #2a3c4d; font-size: 16px;">Noah</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div class="mood-emoji stressed" style="width: 44px; height: 44px; font-size: 22px;">😫</div>
                        <div style="background: white; padding: 4px 10px; border-radius: 15px; color: #6c7a89; font-size: 13px; font-weight: 500; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">3h ago</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
""")
