using UnityEngine;
using UnityEngine.Rendering;

public class InteractiveSnow : MonoBehaviour
{
    [SerializeField] private Shader _snowHeightMapUpdate;
    [SerializeField] private Texture _stepPrint;
    [SerializeField] private Material _snowMaterial;
    [SerializeField] private Transform[] _trailsPositions; //punkty, które maj¹ powodowaæ powstawanie wgnieceñ w œniegu (np. stopy)

    [SerializeField]
    private float _drawDistance = 0.3f; //Dystans pomiêdzy terrainem a punktem, w którym ma byæ narysowany œlad

    private Material _heightMapUpdate;
    private CustomRenderTexture _snowHeightMap;

    private int _index = 0;

    // Shaders properties
    private readonly int DrawPosition = Shader.PropertyToID("_DrawPosition");
    private readonly int DrawAngle = Shader.PropertyToID("_DrawAngle");
    private readonly int DrawBrush = Shader.PropertyToID("_DrawBrush");
    private readonly int HeightMap = Shader.PropertyToID("_HeightMap");

    Terrain terrain; //terrain, na którym jest dodany shader œniegu

    float snowLevel = 0f; // aktualny poziom œniegu
    float maxSnowLevel = 1f; // maksymalny poziom œniegu

    private void Start()
    {
        _heightMapUpdate = CreateHeightMapUpdate(_snowHeightMapUpdate, _stepPrint);
        _snowHeightMap = CreateHeightMap(512, 512, _heightMapUpdate);

        terrain = gameObject.GetComponent<Terrain>();
        terrain.materialTemplate = _snowMaterial;
        terrain.materialTemplate.SetTexture(HeightMap, _snowHeightMap);

        _snowHeightMap.Initialize();
    }


    private void Update()
    {
        DrawTrails();
        _snowHeightMap.Update();

        //zwiêkszanie/zmniejszanie wysokoœci œniegu przyciskami U oraz I
        if (Input.GetKeyDown(KeyCode.U))
        {
            float tmp = terrain.materialTemplate.GetFloat("_HeightAmount") + 0.1f;
            terrain.materialTemplate.SetFloat("_HeightAmount", tmp);
            snowLevel = tmp;
        }
        else if (Input.GetKeyDown(KeyCode.I))
        {
            float tmp = terrain.materialTemplate.GetFloat("_HeightAmount") - 0.1f;
            terrain.materialTemplate.SetFloat("_HeightAmount", tmp);
            snowLevel = tmp;
        }

        // zwiêkszanie poziomu œniegu z czasem
        if (snowLevel < maxSnowLevel)
        {
            snowLevel += Time.deltaTime * 0.01f; // zmiana poziomu œniegu w czasie
            terrain.materialTemplate.SetFloat("_HeightAmount", snowLevel); // aktualizacja poziomu œniegu w shaderze
        }
    }

    //rysuj œlady w œniegu
    private void DrawTrails()
    {
        var trail = _trailsPositions[_index];

        Ray ray = new Ray(trail.transform.position, Vector3.down);

        if (Physics.Raycast(ray, out RaycastHit hit, _drawDistance))
        {
            if (hit.collider.name == gameObject.name)
            {
                Vector2 hitTextureCoord = hit.textureCoord;
                float angle = trail.transform.rotation.eulerAngles.y; //stopieñ rotacji tekstury œladu w œniegu

                _heightMapUpdate.SetVector(DrawPosition, hitTextureCoord);
                _heightMapUpdate.SetFloat(DrawAngle, angle * Mathf.Deg2Rad);
            }
        }

        _index++;

        if (_index >= _trailsPositions.Length)
            _index = 0;
    }

    private CustomRenderTexture CreateHeightMap(int weight, int height, Material material)
    {
        var texture = new CustomRenderTexture(weight, height);

        texture.dimension = TextureDimension.Tex2D;
        texture.format = RenderTextureFormat.R8;
        texture.material = material;
        texture.updateMode = CustomRenderTextureUpdateMode.Realtime;
        texture.doubleBuffered = true;

        return texture;
    }

    private Material CreateHeightMapUpdate(Shader shader, Texture stepPrint)
    {
        var material = new Material(shader);
        material.SetTexture(DrawBrush, stepPrint);
        material.SetVector(DrawPosition, new Vector4(-1, -1, 0, 0));
        return material;
    }
}