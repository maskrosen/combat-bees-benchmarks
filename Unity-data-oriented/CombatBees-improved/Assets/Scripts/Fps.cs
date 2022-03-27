
using UnityEngine;
using UnityEngine.UI;

public class Fps : MonoBehaviour
{
    Text text;
    const string instructions = "Right Click + Drag: <i>Rotate camera</i> \n" +
                                "Scroll: <i>Zoom in/out</i>\n" +
                                "Left Click: <i>Spawn resources</i>\n" +
                                "R Key: <i>Restart</i>\n" +
                                "H Key: <i>Show/hide this info</i>\n";
    float timePassed = 0;
    int frameCount = 0;
    // Start is called before the first frame update
    void Start()
    {
        text = GetComponentsInChildren<Text>()[0];
        QualitySettings.vSyncCount = 0;
    }

    // Update is called once per frame
    void Update()
    {
        if(timePassed > 1)
        {
            var fps = frameCount / timePassed;
            text.text = instructions + "Fps: " + fps + "\n Number of bees: " + GetBeeCount();
            frameCount = 0;
            timePassed = 0;
        }
        timePassed += Time.unscaledDeltaTime;
        frameCount++;
    }

    int GetBeeCount()
    {
        if (BeeManager.instance)
        {
            return BeeManager.instance.bees.Count;
        }
        else
        {
            return Data.AliveCount[0]+ Data.AliveCount[1]+ Data.DeadCount[0]+ Data.DeadCount[1];
        }
    }
}
