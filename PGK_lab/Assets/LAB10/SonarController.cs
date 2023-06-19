using UnityEngine;

public class SonarController : MonoBehaviour
{
    public ParticleSystem particleSystemToPlay;
    public float cooldownTime = 1f;

    private bool isCooldown = false;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) && !isCooldown)
        {
            PlayParticleSystem();
            StartCoroutine(Cooldown());
        }
    }

    private void PlayParticleSystem()
    {
        ParticleSystem newParticleSystem = Instantiate(particleSystemToPlay, transform.position, transform.rotation);
        Destroy(newParticleSystem.gameObject, newParticleSystem.main.duration);
    }

    private System.Collections.IEnumerator Cooldown()
    {
        isCooldown = true;
        yield return new WaitForSeconds(cooldownTime);
        isCooldown = false;
    }
}
