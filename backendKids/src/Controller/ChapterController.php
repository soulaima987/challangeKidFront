<?php

namespace App\Controller;

use App\Entity\Chapter;
use App\Entity\Lesson;
use App\Form\ChapterType;
use App\Form\LessonType;
use App\Repository\ChapterRepository;
use App\Service\ChapterService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[Route('/api/chapter')]
#[OA\Tag(name: 'Chapter')]
// #[IsGranted('ROLE_KID')]
class ChapterController extends AbstractController
{
    private $chapterService;
    private $security;
    public function __construct(ChapterService $chapterService, Security $security)
    {
        $this->chapterService = $chapterService;
        $this->security = $security;
    }
    #[Route('/', name: 'chapter_index', methods: ['GET'])]
    public function index(ChapterRepository $chapterRepository): JsonResponse
    {
        $listJson = [];
        $list = $chapterRepository->findAll();
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->chapterService->chapterToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/{id}', name: 'chapter_show', methods: ['GET'], requirements: ['id' => '\d+'])]
    public function getchapterById($id, ChapterRepository $chapterRepository): JsonResponse
    {
        $chapter = $chapterRepository->find($id);
        $chapter = $this->chapterService->chapterToJson($chapter);
        return new JsonResponse($chapter);
    }

    #[Route('/coach', name: 'chapter_coach', methods: ['GET'])]
    public function getCoachChapters(ChapterRepository $chapterRepository): JsonResponse
    {
        $user = $this->security->getUser();
        $listJson = [];
        $list = $chapterRepository->findBy(["coach" => $user]);
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->chapterService->chapterToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/new', name: 'chapter_new', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "Chapter1",
                "description" => "This is a description for the 1st Chapter",
                "chapterNumber" => 3
            ]
        )
    )]
    public function new(Request $request, EntityManagerInterface $entityManager): Response
    {
        $user = $this->security->getUser();
        $data = json_decode($request->getContent(), true);

        $chapter = new Chapter();
        $chapter->setCoach($user);
        $form = $this->createForm(ChapterType::class, $chapter);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($chapter);
            $entityManager->flush();
        }

        return new JsonResponse(true);
    }

    #[Route('/{title}', name: 'chapter_show', methods: ['GET'])]
    public function show(ChapterRepository $chapterRepository, $title): Response
    {
        $chapter = $chapterRepository->findOneBy(['title' => $title]);
        $chapter = $this->chapterService->chapterToJson($chapter);
        return new JsonResponse($chapter);
    }

    #[Route('/{id}/edit', name: 'chapter_edit', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "Chapter111",
                "description" => "This is a description for the 111th Chapter",
                "chapterNumber" => 6
            ]
        )
    )]
    public function edit($id, Request $request, ChapterRepository $chapterRepository, EntityManagerInterface $entityManager): Response
    {
        $chapter = $chapterRepository->find($id);

        $data = json_decode($request->getContent(), true);
        $form = $this->createForm(ChapterType::class, $chapter);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($chapter);
            $entityManager->flush();

            return new JsonResponse(['status' => 'Chapter updated successfully']);
        }

        return new JsonResponse(['error' => 'An error has occured']);
    }

    #[Route('/delete/{id}', name: 'chapter_delete', methods: ['DELETE'])]
    public function delete($id, ChapterRepository $chapterRepository, EntityManagerInterface $entityManager): Response
    {
        $chapter = $chapterRepository->find($id);
        if (!$chapter) {
            throw new NotFoundHttpException('chapter$chapter not found');
        }

        $entityManager->remove($chapter);
        $entityManager->flush();

        return new JsonResponse(['status' => 'The chapter$chapter has been deleted']);
    }

    #[Route('/{id}/addLesson', name: 'chapter_add_lessons', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "lessons" => ["1st Lesson", "2nd Lesson", "5th Lesson"],
            ]
        )
    )]
    public function addLesson($id, Request $request, ChapterRepository $chapterRepository): JsonResponse
    {
        $chapter = $chapterRepository->find($id);
        $data = $request->toArray();
        $lessonTitles = $data["lessons"];
        $this->chapterService->addLessons($chapter, $lessonTitles);

        return new JsonResponse(true);
    }

    #[Route('/{chapterId}/createLesson', name: 'chapter_create_lesson', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "1st Lesson",
                "description" => "This is the description of the first lesson",
                "LessonNumber" => 1,
            ]
        )
    )]
    public function createLessonForChapter($chapterId, Request $request, EntityManagerInterface $entityManager, ChapterRepository $chapterRepository): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        $chapter = $chapterRepository->find($chapterId);
        $coach = $this->security->getUser();

        $lesson = new Lesson();
        $lesson->setCoach($coach);
        $form = $this->createForm(LessonType::class, $lesson);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $chapter->addLesson($lesson);
            $entityManager->persist($chapter);
            $entityManager->persist($lesson);
            $entityManager->flush();
        }

        return new JsonResponse(true);
    }
}
